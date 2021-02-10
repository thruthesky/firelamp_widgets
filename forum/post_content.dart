import 'package:flutter/material.dart';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';

class PostContent extends StatelessWidget {
  PostContent(this.post);
  final ApiPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Space.sm),
            child: SelectableText('${post.postTitle}',
                style: TextStyle(
                  fontSize: Space.md,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Space.sm),
            child: SelectableText('${post.postContent}', style: TextStyle(fontSize: Space.sm)),
          ),
        ],
      ),
    );
  }
}
