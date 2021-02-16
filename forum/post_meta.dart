import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostMeta extends StatelessWidget {
  PostMeta(this.post);
  final ApiPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          SizedBox(width: Space.xs),
          Icon(
            Icons.circle,
            size: Space.xxs,
            color: Colors.greenAccent,
          ),
          SizedBox(width: Space.xs),
          Text('${post.category}'),
          SizedBox(width: Space.xs),
          Icon(
            Icons.circle,
            size: Space.xxs,
            color: Colors.redAccent,
          ),
          SizedBox(width: Space.xs),
          Text('${post.id}'),
        ]),
      ],
    );
  }
}
