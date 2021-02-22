import 'dart:async';

import 'package:dalgona/firelamp_widgets/functions.dart';
import 'package:dalgona/services/defines.dart';
import 'package:dalgona/services/globals.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageButtomActions extends StatefulWidget {
  @override
  _ChatMessageButtomActionsState createState() => _ChatMessageButtomActionsState();
}

class _ChatMessageButtomActionsState extends State<ChatMessageButtomActions> {
  final textController = TextEditingController();

  /// upload progress
  double progress = 0;

  // send a message to the room users
  sendMessage() async {
    String text = textController.text;
    if (text.isEmpty) return;

    textController.text = '';

    // print(text);
    // @todo show spinner while sending messages
    try {
      await api.chat.sendMessage(
        text: text,
      );

      /// Send Push Notification Silently
      api.chat.sendChatPushMessage(text);
    } catch (e) {
      // @todo show error on screen if there is any error.
      if (e == ERROR_EMPTY_TOKENS) {
        // print('No tokens to sends. It is not a critical error');
      } else {
        onError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (progress > 0)
          LinearProgressIndicator(
            value: progress,
          ),
        Padding(
          padding: EdgeInsets.all(sm),
          child: Row(
            children: [
              /// Upload Icon Button
              IconButton(
                /// if progress is not 0, show loader.
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  print('upload and sending photo');
                  try {
                    /// upload to php backend
                    ApiFile file = await imageUpload(
                      onProgress: (p) => setState(
                        () {
                          if (p == 100) {
                            Timer(Duration(milliseconds: 400), () {
                              progress = 0;
                            });
                          } else {
                            progress = p / 100;
                          }
                        },
                      ),
                    );

                    /// send url to firebase
                    await api.chat.sendMessage(
                      text: file.thumbnailUrl,
                    );

                    /// Send Push Notification Silently
                    api.chat
                        .sendChatPushMessage('${api?.chat?.otherUser?.nickname} send you a photo');
                  } catch (e) {
                    progress = 0;
                    onError(e);
                  }
                },
              ),
              Expanded(
                child: TextFormField(
                  controller: textController,
                  onEditingComplete: sendMessage,
                  decoration: InputDecoration(
                    hintText: "Please enter your message.",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.amber[600],
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[300],
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
