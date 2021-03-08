import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class ForumBasicPostTitle extends StatelessWidget {
  const ForumBasicPostTitle(
    this.post, {
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final ApiPost post;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(post.user.photoUrl),
      title: Text(post.title),
      onTap: onTap,
    );
  }
}
