import 'package:dalgona/firelamp_widgets/forum/post/post_preview.dart';
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
    this.open = false,
    this.onError,
  }) : super(key: key);

  final ApiForum forum;
  // final int i;
  final ApiPost post;
  final List<Widget> actions;
  final Function onTitleTap;
  final Function onError;
  final bool open;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  bool get showContent {
    if (widget.open) return true;
    if (widget.post.display) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBox(
      margin: EdgeInsets.all(Space.xs),
      padding: EdgeInsets.all(Space.xsm),
      boxColor: Colors.white,
      radius: 10,
      child: showContent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTitleTap,
                  child: Row(
                    children: [
                      UserAvatar(widget.post.profilePhotoUrl, size: 40),
                      SizedBox(width: Space.sm),
                      PostMeta(widget.post),
                    ],
                  ),
                ),
                SizedBox(height: Space.sm),
                Text('${widget.post.postTitle}', style: stylePostTitle),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Space.sm),
                  child: SelectableText('${widget.post.postContent}',
                      style: TextStyle(fontSize: Space.sm, wordSpacing: 2)),
                ),
                FilesView(postOrComment: widget.post),
                Divider(),
                Row(children: widget.actions),
                CommentForm(
                    post: widget.post,
                    forum: widget.forum,
                    comment: ApiComment(),
                    onError: widget.onError),
                CommentList(post: widget.post, forum: widget.forum),
              ],
            )
          // : PostPreview(widget.post, onTap: () => setState(() => widget.post.display = true)),
          : PostPreview(widget.post, onTap: widget.onTitleTap),
    );
  }
}
