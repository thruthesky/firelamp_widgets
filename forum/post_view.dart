import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/comment_form.dart';
import 'package:dalgona/firelamp_widgets/forum/comment_list.dart';
import 'package:dalgona/firelamp_widgets/forum/post_content.dart';
import 'package:dalgona/firelamp_widgets/forum/post_meta.dart';
import 'package:dalgona/firelamp_widgets/forum/files_view.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';

class PostView extends StatefulWidget {
  const PostView({
    Key key,
    this.i,
    this.forum,
    this.actions,
    this.onTitlePressed,
  }) : super(key: key);

  final ApiForum forum;
  final int i;
  final List<Widget> actions;
  final Function onTitlePressed;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    ApiForum forum = widget.forum;
    ApiPost post = widget.forum.posts[widget.i];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(Space.sm),
      padding: EdgeInsets.all(Space.sm),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostMeta(
            post,
            avatar: UserAvatar(post.featuredImageThumbnailUrl, size: 40),
            redirectOnTap: widget.onTitlePressed,
          ),
          PostContent(post),
          FilesView(postOrComment: post),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.actions,
          ),
          CommentForm(
            post: post,
            forum: forum,
            comment: ApiComment(),
          ),
          CommentList(post: post, forum: forum),
        ],
      ),
    );
  }
}
