import 'package:dalgona/firelamp_widgets/chat/message/bottom_actions.dart';
import 'package:dalgona/firelamp_widgets/chat/message/view.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatMessageListWidget extends StatefulWidget {
  ChatMessageListWidget({
    this.onImageRenderCompelete,
    this.onError,
    Key key,
  }) : super(key: key);

  final Function onImageRenderCompelete;
  final Function onError;

  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  var _tapPosition;

  @override
  Widget build(BuildContext context) {
    return Api.instance.chat.loading
        ? Spinner()
        : Column(
            children: [
              Expanded(
                child: KeyboardDismissOnTap(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    controller: Api.instance.chat.scrollController,
                    itemCount: Api.instance.getChatMessagesCount,
                    itemBuilder: (_, i) {
                      final message = ApiChatMessage.fromData(Api.instance.chat.messages[i]);
                      return message.isMine ? myMessage(message) : otherMessage(message);
                    },
                  ),
                ),
              ),
              ChatMessageButtomActions(onError: widget.onError)
            ],
          );
  }

  Widget myMessage(ApiChatMessage message) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: ChatMessageViewWidget(message: message, onImageRenderCompelete: imageRenderComplete),
      onTapDown: _storePosition,
      onLongPress: () => onLongPressShowMenu(message),
    );
  }

  Widget otherMessage(ApiChatMessage message) {
    return ChatMessageViewWidget(message: message, onImageRenderCompelete: imageRenderComplete);
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void onLongPressShowMenu(ApiChatMessage message) {
    {
      final RenderBox overlay = Overlay.of(context).context.findRenderObject();
      showMenu(
        context: context,
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: "delete",
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                Text("Delete"),
              ],
            ),
          ),
          PopupMenuItem(
            value: "edit",
            child: Row(
              children: <Widget>[
                Icon(Icons.edit),
                Text("Edit"),
              ],
            ),
          )
        ],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size // Bigger rect, the entire screen
            ),
      ).then((value) {
        if (value == null) return;
        if (value == 'delete') {
          Api.instance.chat.deleteMessage(message);
        }
        if (value == 'edit') {
          Api.instance.chat.editMessage(message);
        }
      });
    }
  }

  void imageRenderComplete() {
    if (Api.instance.chat.atBottom || Api.instance.chat.pageNo == 1) {
      Api.instance.chat.lastImage = '';
      Api.instance.chat.scrollToBottom();
    }
    if (widget.onImageRenderCompelete != null) widget.onImageRenderCompelete();
  }
}
