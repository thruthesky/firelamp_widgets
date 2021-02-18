import 'package:dalgona/firelamp_widgets/defines.dart';
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


  String get listText {
    final commentCount = widget.post.comments.length;
    final text = '$commentCount comment';
    return commentCount > 1 ? text + 's' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.post.comments.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Space.xsm),
                Text(
                  listText,
                  style: TextStyle(fontSize: Space.xsm, color: Colors.grey[500]),
                ),
                for (ApiComment comment in widget.post.comments)
                  CommentView(
                    comment: comment,
                    post: widget.post,
                    forum: widget.forum,
                  ),
              ],
            )
          : Padding(
              padding: EdgeInsets.only(top: Space.xsm, left: Space.xsm),
              child: Text(
                'No comments yet ..',
                style: TextStyle(fontSize: Space.xsm, color: Colors.grey[500]),
              ),
            ),
    );
  }
}
