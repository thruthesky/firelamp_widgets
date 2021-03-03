import 'package:dalgona/firelamp_widgets/forum/post/post_preview.dart';
import 'package:dalgona/firelamp_widgets/forum/post/post_meta.dart';
import 'package:dalgona/firelamp_widgets/widgets/rounded_box.dart';
import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_form.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_list.dart';
import 'package:dalgona/firelamp_widgets/forum/shared/files_view.dart';

class PostViewWithThumbnailAndAvatar extends StatefulWidget {
  const PostViewWithThumbnailAndAvatar({
    Key key,
    this.post,
    this.forum,
    this.actions,
    this.onTitleTap,
    this.open = false,
    this.titleFirst = false,
    this.onError,
  }) : super(key: key);

  final ApiForum forum;
  final bool titleFirst;
  final ApiPost post;
  final List<Widget> actions;
  final Function onTitleTap;
  final Function onError;
  final bool open;

  @override
  _PostViewWithThumbnailAndAvatarState createState() => _PostViewWithThumbnailAndAvatarState();
}

class _PostViewWithThumbnailAndAvatarState extends State<PostViewWithThumbnailAndAvatar> {
  bool get showContent {
    if (widget.open) return true;
    if (widget.post.display) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget title =
        Text('${widget.post.title != '' ? widget.post.title : 'No title'}', style: stylePostTitle);
    Widget meta = PostMeta(widget.post, showAvatar: true);

    return RoundedBox(
      padding: EdgeInsets.all(Space.sm),
      boxColor: Colors.white,
      radius: 10,
      child: showContent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTitleTap,
                  child: widget.titleFirst ? title : meta,
                ),
                SizedBox(height: Space.xxs),

                /// show only when `titleFirst` is `false`
                if (!widget.titleFirst) title,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Space.sm),
                  child: SelectableText(
                    '${widget.post.content}',
                    style: TextStyle(fontSize: Space.sm, wordSpacing: 2),
                  ),
                ),
                FilesView(postOrComment: widget.post),

                /// show only when `titleFirst` is `true`
                if (widget.titleFirst) meta,
                Divider(),
                Row(children: widget.actions),
                CommentForm(
                  post: widget.post,
                  forum: widget.forum,
                  comment: ApiComment(),
                  onError: widget.onError,
                  onSuccess: () => setState(() {}),
                ),
                CommentList(post: widget.post, forum: widget.forum),
              ],
            )
          : PostPreview(widget.post, onTap: widget.onTitleTap),
    );
  }
}
