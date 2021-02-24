import 'package:dalgona/firelamp_widgets/widgets/image.cache.dart';
import 'package:dalgona/services/defines.dart';
import 'package:dalgona/services/globals.dart';
import 'package:dalgona/services/helper.functions.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatMessageViewWidget extends StatefulWidget {
  ChatMessageViewWidget({
    this.message,
    this.onImageRenderCompelete,
    Key key,
  }) : super(key: key);

  final ApiChatMessage message;
  final Function onImageRenderCompelete;

  @override
  _ChatMessageViewWidgetState createState() => _ChatMessageViewWidgetState();
}

class _ChatMessageViewWidgetState extends State<ChatMessageViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChatBubble(
          clipper: widget.message.isMine
              ? ChatBubbleClipper4(type: BubbleType.sendBubble)
              : ChatBubbleClipper4(type: BubbleType.receiverBubble),
          alignment: widget.message.isMine ? Alignment.topRight : Alignment.topLeft,
          margin: EdgeInsets.only(top: 20),
          backGroundColor: Colors.blue,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: widget.message.isImage
                ? CachedImage(
                    widget.message.text,
                    onLoadComplete: () {
                      if (widget.message.text == Api.instance.chat.lastImage) {
                        print('load compelete for the last image only: ${widget.message.text}');
                        widget.onImageRenderCompelete();
                      }
                    },
                  )
                : Text(
                    api.chat
                        .translateIfChatProtocol(widget.message.text ?? widget.message.protocol),
                    textAlign: widget.message.isMine ? TextAlign.right : TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(xs),
          child: Row(
            mainAxisAlignment:
                widget.message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Api.instance.chat.isMessageOnEdit(widget.message)
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(right: sm),
                        child: Text(
                          'Edit Cancel',
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                      onTap: Api.instance.chat.cancelEdit,
                    )
                  : SizedBox(),
              Text(
                dateTimeFromTimeStamp(widget.message.createdAt),
                style: TextStyle(fontSize: 8),
                // textAlign: widget.message.isMine ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        )
      ],
    );
  }
}
