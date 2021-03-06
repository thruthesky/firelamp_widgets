import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/basic/post_title.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_form.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_list.dart';
import 'package:dalgona/firelamp_widgets/forum/shared/files_view.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostViewWithAvatar extends StatefulWidget {
  PostViewWithAvatar({
    this.post,
    this.forum,
    this.actions = const [],
    this.onTap,
    this.onError,
    Key key,
  }) : super(key: key);

  final ApiPost post;
  final ApiForum forum;
  final List<Widget> actions;
  final Function onTap;
  final Function onError;

  @override
  _PostViewWithAvatarState createState() => _PostViewWithAvatarState();
}

class _PostViewWithAvatarState extends State<PostViewWithAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ForumBasicPostTitle(
          widget.post,
          onTap: widget.onTap,
        ),
        if (widget.post.display) DisplayContent(widget.post),
        if (widget.post.display) Row(children: widget.actions),
        if (widget.post.display)
          CommentForm(
            comment: ApiComment(),
            post: widget.post,
            forum: widget.forum,
          ),
        if (widget.post.display)
          CommentList(
            post: widget.post,
            forum: widget.forum,
            onError: widget.onError,
          ),
      ],
    );
  }
}

class DisplayContent extends StatelessWidget {
  const DisplayContent(this.post);
  final ApiPost post;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Space.sm),
            width: double.infinity,
            // color: Colors.grey[100],
            child: Text(post.content),
          ),
          if (post.files.length > 0) FilesView(postOrComment: post),
          Divider(thickness: 1.3),
        ],
      ),
    );
  }
}
