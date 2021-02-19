import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostMeta extends StatelessWidget {
  PostMeta(this.post);
  final ApiPost post;

  bool get showName {
    return post.files.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showName) ...[
          Text(
            '${post.displayName}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: Space.xsm),
          ),
          SizedBox(width: Space.xs),
          Icon(
            Icons.circle,
            size: Space.xxs,
            color: Colors.blueAccent,
          ),
          SizedBox(width: Space.xs),
        ],
        Text('${post.shortDateTime}', style: TextStyle(fontSize: Space.xsm)),
        SizedBox(width: Space.xs),
        Icon(Icons.circle, size: Space.xxs, color: Colors.blueAccent),
        SizedBox(width: Space.xs),
        Text('${post.category}', style: TextStyle(fontSize: Space.xsm)),
        SizedBox(width: Space.xs),
      ],
    );
  }
}
