import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';
import 'package:dalgona/services/defines.dart';
import 'package:dalgona/services/helper.functions.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoomViewWidget extends StatefulWidget {
  ChatRoomViewWidget(this.room, {this.onTap});

  final ApiChatUserRoom room;
  final Function onTap;

  @override
  _ChatRoomViewWidgetState createState() => _ChatRoomViewWidgetState();
}

class _ChatRoomViewWidgetState extends State<ChatRoomViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(
        widget.room.profilePhotoUrl ?? '',
      ),
      title: Text(widget.room.displayName ?? ''),
      subtitle: Text(widget.room.text ?? ''),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shortDateTimeFromTimeStamp(widget.room.createdAt),
            style: subtitle1,
          ),
          Spacer(),
          if (widget.room.newMessages > 0)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: md),
              child: Chip(
                labelPadding: EdgeInsets.fromLTRB(4, -4, 4, -4),
                label: Text(
                  '${widget.room.newMessages}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            ),
          Spacer(),
        ],
      ),
      onTap: () {
        if (widget.onTap != null) widget.onTap();
      },
    );
  }
}
