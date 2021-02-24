import 'package:dalgona/firelamp_widgets/chat/room/view.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomListWidget extends StatefulWidget {
  ChatRoomListWidget({
    @required this.onChatRoomTap,
  });

  final Function onChatRoomTap;
  @override
  _ChatRoomListWidgetState createState() => _ChatRoomListWidgetState();
}

class _ChatRoomListWidgetState extends State<ChatRoomListWidget> {
  @override
  Widget build(BuildContext context) {
    return Api.instance.roomList?.fetched != true
        ? Spinner()
        : Api.instance.getChatRoomCount > 0
            ? ListView.builder(
                itemCount: Api.instance.getChatRoomCount,
                itemBuilder: (_, i) {
                  ApiChatUserRoom room = Api.instance.roomList.rooms[i];
                  return ChatRoomViewWidget(room, onTap: () {
                    if (widget.onChatRoomTap != null) widget.onChatRoomTap(room);
                  });
                },
              )
            : Center(
                child: Text('No Chats...'),
              );
  }
}
