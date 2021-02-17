import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentContent extends StatelessWidget {
  final ApiComment comment;

  CommentContent(this.comment);

  @override
  Widget build(BuildContext context) {
    return comment.commentContent.isNotEmpty
        ? Padding(
          padding: EdgeInsets.only(top: Space.sm),
            child: SelectableText('${comment.commentContent}'),
          )
        : SizedBox.shrink();
  }
}
