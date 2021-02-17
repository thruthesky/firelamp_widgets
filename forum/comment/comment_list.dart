import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';

import 'package:dalgona/firelamp_widgets/forum/comment/comment_view.dart';

class CommentList extends StatefulWidget {
  CommentList({
    this.post,
    this.forum,
  });
  final ApiPost post;
  final ApiForum forum;
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          for (ApiComment comment in widget.post.comments)
            CommentView(
              comment: comment,
              post: widget.post,
              forum: widget.forum,
            ),
        ],
      ),
    );
  }
}
