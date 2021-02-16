import 'package:dalgona/firelamp_widgets/widgets/popup_button.dart';
import 'package:dalgona/firelamp_widgets/forum/vote_button.dart';
import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';
import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/functions.dart';
import 'package:dalgona/firelamp_widgets/forum/comment_meta.dart';
import 'package:dalgona/firelamp_widgets/forum/comment_form.dart';

import 'package:dalgona/firelamp_widgets/forum/files_view.dart';
import 'package:dalgona/firelamp_widgets/user/user_avatar.dart';

class CommentView extends StatefulWidget {
  const CommentView({
    Key key,
    this.comment,
    this.post,
    @required this.forum,
  }) : super(key: key);

  final ApiComment comment;
  final ApiPost post;
  final ApiForum forum;
  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  /// when user is done selecting from the popup menu.
  onPopupMenuItemSelected(selected) async {
    /// Edit
    if (selected == 'edit') {
      setState(() {
        widget.comment.mode = CommentMode.edit;
      });
    }

    /// Delete
    if (selected == 'delete') {
      bool conf = await confirm(
        'Confirm',
        'Delete Comment?',
      );
      if (conf == false) return;

      try {
        await Api.instance.deleteComment(widget.comment, widget.post);
        widget.forum.render();
      } catch (e) {
        error(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: Space.sm, left: Space.sm * (widget.comment.depth - 1)),
      padding: EdgeInsets.all(Space.sm),
      decoration: BoxDecoration(
        color: Color(0x338fb1cc),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentMeta(widget.comment, avatar: UserAvatar(widget.comment.userPhoto, size: 40)),
          if (widget.comment.mode == CommentMode.none ||
              widget.comment.mode == CommentMode.reply) ...[
            if (widget.comment.commentContent.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: Space.sm),
                child: SelectableText('${widget.comment.commentContent}'),
              ),
            FilesView(postOrComment: widget.comment),
            Divider(),
            Row(children: [
              TextButton(
                child: Text(widget.comment.mode == CommentMode.reply ? 'Cancel' : 'Reply'),
                onPressed: () {
                  setState(() {
                    widget.comment.mode = widget.comment.mode == CommentMode.reply
                        ? CommentMode.none
                        : CommentMode.reply;
                  });
                },
              ),
              if (widget.forum.showLike) VoteButton(postOrComment: widget.comment),
              if (widget.forum.showDislike)
                VoteButton(postOrComment: widget.comment, isLike: false),
              Spacer(),
              if (widget.comment.isMine)
                PopUpButton(items: [
                  PopupMenuItem(
                      child: Row(children: [
                        Icon(Icons.edit, size: Space.sm, color: Colors.greenAccent),
                        SizedBox(width: Space.xs),
                        Text('Edit')
                      ]),
                      value: 'edit'),
                  PopupMenuItem(
                      child: Row(children: [
                        Icon(Icons.delete, size: Space.sm, color: Colors.redAccent),
                        SizedBox(width: Space.xs),
                        Text('Delete')
                      ]),
                      value: 'delete')
                ], onSelected: onPopupMenuItemSelected)
            ]),
          ],
          if (widget.comment.mode == CommentMode.reply)
            CommentForm(
                parent: widget.comment,
                comment: ApiComment(),
                post: widget.post,
                forum: widget.forum),
          if (widget.comment.mode == CommentMode.edit) ...[
            CommentForm(comment: widget.comment, post: widget.post, forum: widget.forum),
            IconButton(
              icon: Icon(Icons.close, color: Colors.redAccent),
              onPressed: () {
                setState(() {
                  widget.comment.mode = CommentMode.none;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}
