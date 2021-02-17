import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_form.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_list.dart';
import 'package:dalgona/firelamp_widgets/forum/post/post_meta.dart';
import 'package:dalgona/firelamp_widgets/forum/shared/files_view.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';

class PostView extends StatefulWidget {
  const PostView({
    Key key,
    this.i,
    this.forum,
    this.actions,
  }) : super(key: key);

  final ApiForum forum;
  final int i;
  final List<Widget> actions;

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
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(post.featuredImageThumbnailUrl, size: 40),
              SizedBox(width: Space.xs),
              PostMeta(post),
            ],
          ),
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
          FilesView(postOrComment: post),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: widget.actions),
          CommentForm(post: post, forum: forum, comment: ApiComment()),
          CommentList(post: post, forum: forum),
        ],
      ),
    );
  }
}
