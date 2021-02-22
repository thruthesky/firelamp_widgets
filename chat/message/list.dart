import 'package:dalgona/firelamp_widgets/chat/message/view.dart';
import 'package:dalgona/services/globals.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageListWidget extends StatefulWidget {
  ChatMessageListWidget({
    this.scrollController,
    this.onImageRenderCompelete,
    Key key,
  }) : super(key: key);

  final ScrollController scrollController;
  final Function onImageRenderCompelete;

  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      controller: widget.scrollController,
      itemCount: api?.chat?.messages?.length ?? 0,
      itemBuilder: (_, i) {
        final message = ApiChatMessage.fromData(api.chat.messages[i]);
        return message.isMine
            ? GestureDetector(
                child: ChatMessageViewWidget(
                    message: message, onImageRenderCompelete: widget.onImageRenderCompelete),
                onLongPress: () {
                  print('long press');
                },
              )
            : ChatMessageViewWidget(
                message: message, onImageRenderCompelete: widget.onImageRenderCompelete);
      },
    );
  }
}
