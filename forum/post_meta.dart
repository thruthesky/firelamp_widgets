import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostMeta extends StatelessWidget {
  PostMeta(this.post, {this.avatar});
  final ApiPost post;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (avatar != null) avatar,
        SizedBox(width: Space.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${post.authorName}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Space.sm,
                )),
            Row(children: [
              Icon(
                Icons.circle,
                size: Space.xxs,
                color: Colors.blueAccent,
              ),
              SizedBox(width: Space.xs),
              Text('${post.shortDateTime}'),
            ]),
          ],
        )
      ],
    );
  }
}
