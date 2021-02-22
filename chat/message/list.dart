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

class MessageList extends StatefulWidget {
  MessageList({
    this.scrollController,
    Key key,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      controller: widget.scrollController,
      itemCount: api?.chat?.messages?.length ?? 0,
      itemBuilder: (_, i) {
        final message = ApiChatMessage.fromData(api.chat.messages[i]);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChatBubble(
              clipper: message.isMine
                  ? ChatBubbleClipper4(type: BubbleType.sendBubble)
                  : ChatBubbleClipper4(type: BubbleType.receiverBubble),
              alignment: message.isMine ? Alignment.topRight : Alignment.topLeft,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: message.isImage
                    ? CachedImage(message.text)
                    : Text(
                        api.chat.translateIfChatProtocol(message.text ?? message.protocol),
                        textAlign: message.isMine ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(xs),
              child: Text(
                dateTimeFromTimeStamp(message.createdAt),
                style: TextStyle(fontSize: 8),
                textAlign: message.isMine ? TextAlign.right : TextAlign.left,
              ),
            )
          ],
        );
      },
    );
  }
}
