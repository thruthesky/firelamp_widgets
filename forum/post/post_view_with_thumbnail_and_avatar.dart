import 'package:dalgona/firelamp_widgets/forum/post/post_preview.dart';
import 'package:dalgona/firelamp_widgets/forum/post/post_meta.dart';
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
    this.onError,
  }) : super(key: key);

  final ApiForum forum;
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
    return showContent
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTitleTap,
                child: PostMeta(widget.post, showAvatar: true, isInlineName: widget.open),
              ),
              SizedBox(height: Space.sm),
              Text('${widget.post.title}', style: stylePostTitle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Space.sm),
                child: SelectableText(
                  '${widget.post.content}',
                  style: TextStyle(fontSize: Space.sm, wordSpacing: 2),
                ),
              ),
              FilesView(postOrComment: widget.post),
              Divider(height: Space.xs, thickness: 1.3),
              Row(children: widget.actions),
              CommentForm(
                post: widget.post,
                forum: widget.forum,
                comment: ApiComment(),
                onError: widget.onError,
                onSuccess: () => setState(() {}),
              ),
              CommentList(
                post: widget.post,
                forum: widget.forum,
                onError: widget.onError,
              ),
            ],
          )
        : PostPreview(widget.post, widget.forum, onTap: widget.onTitleTap);
  }
}
