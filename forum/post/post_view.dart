import 'package:dalgona/firelamp_widgets/widgets/rounded_box.dart';
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
    this.post,
    this.forum,
    this.actions,
    this.onTitleTap,
  }) : super(key: key);

  final ApiForum forum;
  // final int i;
  final ApiPost post;
  final List<Widget> actions;
  final Function onTitleTap;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return RoundedBox(
      margin: EdgeInsets.all(Space.xs),
      padding: EdgeInsets.all(Space.xsm),
      boxColor: Colors.grey[100],
      radius: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onTitleTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserAvatar(widget.post.featuredImageThumbnailUrl, size: 40),
                    SizedBox(width: Space.sm),
                    PostMeta(widget.post),
                  ],
                ),
                SizedBox(height: Space.sm),
                Text(
                  '${widget.post.postTitle}',
                  style: stylePostTitle,
                  maxLines: widget.post.display ? null : 2,
                  overflow: widget.post.display ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (widget.post.display) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: Space.sm),
              child: SelectableText('${widget.post.postContent}',
                  style: TextStyle(fontSize: Space.sm, wordSpacing: 2)),
            ),
            FilesView(postOrComment: widget.post),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: widget.actions),
            CommentForm(post: widget.post, forum: widget.forum, comment: ApiComment()),
            CommentList(post: widget.post, forum: widget.forum),
          ],
        ],
      ),
    );
  }
}
