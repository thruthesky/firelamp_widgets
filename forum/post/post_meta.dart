import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostMeta extends StatelessWidget {
  PostMeta(this.post, {this.showAvatar = false});

  final ApiPost post;
  final bool showAvatar;

  bool get showName {
    return post.files.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Widget name = Text(
      '${post.display ? post.authorName : post.displayName}',
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: Space.sm),
    );

    List<Widget> otherMeta = [
      Text('${post.shortDateTime}', style: TextStyle(fontSize: Space.xsm)),
      SizedBox(width: Space.xs),
      Icon(Icons.circle, size: Space.xxs, color: Colors.blueAccent),
      SizedBox(width: Space.xs),
      Text('${post.category}', style: TextStyle(fontSize: Space.xsm)),
      SizedBox(width: Space.xs),
    ];

    return Container(
      child: Row(
        children: [
          if (showAvatar)
          UserAvatar(post.profilePhotoUrl, size: 40),
          SizedBox(width: Space.sm),
          // PostMeta(post),
          if (post.display)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [name, SizedBox(height: Space.xxs), Row(children: otherMeta)],
            ),
          if (post.display == false)
            Row(
              children: [
                if (showName) ...[
                  name,
                  SizedBox(width: Space.xs),
                  Icon(
                    Icons.circle,
                    size: Space.xxs,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: Space.xs),
                ],
                ...otherMeta
              ],
            ),
        ],
      ),
    );
  }
}
