import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class CommentMeta extends StatelessWidget {
  final ApiComment comment;
  final Widget avatar;

  CommentMeta(this.comment, {this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (avatar != null) avatar,
          SizedBox(width: Space.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comment.commentAuthor}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Space.sm,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: Space.xxs,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: Space.xs),
                  Text('${comment.shortDateTime}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
