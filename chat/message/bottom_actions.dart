import 'dart:async';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/functions.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageButtomActions extends StatefulWidget {
  ChatMessageButtomActions({this.onError});
  final Function onError;

  @override
  _ChatMessageButtomActionsState createState() => _ChatMessageButtomActionsState();
}

class _ChatMessageButtomActionsState extends State<ChatMessageButtomActions> {
  /// upload progress
  double progress = 0;

  /// show loader if sending is true
  bool sending = false;

  // send a message to the room users
  sendMessage() async {
    String text = Api.instance.chat.textController.text;
    if (text.isEmpty || sending) return;
    sending = true;

    Api.instance.chat.textController.text = '';

    try {
      if (Api.instance.chat.isMessageEdit == null) {
        await Api.instance.chat.sendMessage(
          text: text,
        );

        /// Send Push Notification Silently
        Api.instance.chat.sendChatPushMessage(text).catchError((e) {
          if (e == ERROR_EMPTY_TOKENS) {
            // print('No tokens to sends. It is not a critical error');
          } else {
            onError(e);
          }
        });
      } else {
        await Api.instance.chat.sendMessage(
          text: text,
        );
      }
      sending = false;
    } catch (e) {
      sending = false;
      onError(e);
    }
    Api.instance.chat.notify();
  }

  onError(dynamic e) {
    if (widget.onError != null) widget.onError(e);
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
          padding: EdgeInsets.all(Space.sm),
          child: Row(
            children: [
              /// Upload Icon Button
              uploadIconButton(),
              Expanded(
                child: TextFormField(
                  controller: Api.instance.chat.textController,
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
              sending
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Spinner(),
                    )
                  : IconButton(
                      onPressed: sendMessage,
                      icon: Icon(Icons.send),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget uploadIconButton() {
    return IconButton(
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
          await Api.instance.chat.sendMessage(
            text: file.thumbnailUrl,
          );

          /// Send Push Notification Silently
          Api.instance.chat
              .sendChatPushMessage('${Api.instance?.chat?.otherUser?.nickname} send you a photo')
              .catchError((e) {
            if (e == ERROR_EMPTY_TOKENS) {
              // print('No tokens to sends. It is not a critical error');
            } else {
              onError(e);
            }
          });
        } catch (e) {
          progress = 0;
          onError(e);
        }
      },
    );
  }
}
