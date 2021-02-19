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

    return post.display
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [name, SizedBox(height: Space.xxs), Row(children: otherMeta)],
          )
        : Row(
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
          );
  }
}
