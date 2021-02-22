import 'package:dalgona/firelamp_widgets/chat/room/view.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:dalgona/services/globals.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomListWidget extends StatefulWidget {
  @override
  _ChatRoomListWidgetState createState() => _ChatRoomListWidgetState();
}

class _ChatRoomListWidgetState extends State<ChatRoomListWidget> {
  @override
  Widget build(BuildContext context) {
    return api.roomList?.fetched != true
        ? Spinner()
        : api.roomList.rooms.length > 0
            ? ListView.builder(
                itemCount: api.roomList.rooms.length,
                itemBuilder: (_, i) {
                  ApiChatUserRoom room = api.roomList.rooms[i];
                  return ChatRoomViewWidget(room, onTap: () {
                    app.openChatRoom(room.userId);
                  });
                },
              )
            : Center(
                child: Text('No Chats...'),
              );
  }
}
