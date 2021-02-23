import 'package:dalgona/firelamp_widgets/chat/message/bottom_actions.dart';
import 'package:dalgona/firelamp_widgets/chat/message/view.dart';
import 'package:dalgona/services/globals.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatMessageListWidget extends StatefulWidget {
  ChatMessageListWidget({
    this.scrollController,
    this.onImageRenderCompelete,
    this.onError,
    Key key,
  }) : super(key: key);

  final ScrollController scrollController;
  final Function onImageRenderCompelete;
  final Function onError;

  @override
  _ChatMessageListWidgetState createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  var _tapPosition;
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
          api.chat.deleteMessage(message);
        }
        if (value == 'edit') {
          // api.chat.editMessage(message);
          print('how to edit?');
        }
        print(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: KeyboardDismissOnTap(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              controller: widget.scrollController,
              itemCount: api?.chat?.messages?.length ?? 0,
              itemBuilder: (_, i) {
                final message = ApiChatMessage.fromData(api.chat.messages[i]);
                return message.isMine
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: ChatMessageViewWidget(
                            message: message,
                            onImageRenderCompelete: widget.onImageRenderCompelete),
                        onTapDown: _storePosition,
                        onLongPress: () => onLongPressShowMenu(message),
                      )
                    : ChatMessageViewWidget(
                        message: message, onImageRenderCompelete: widget.onImageRenderCompelete);
              },
            ),
          ),
        ),
        ChatMessageButtomActions(onError: widget.onError)
      ],
    );
  }
}
