import 'package:dalgona/firelamp_widgets/forum/comment/comment_content.dart';
import 'package:dalgona/firelamp_widgets/widgets/popup_button.dart';
import 'package:dalgona/firelamp_widgets/forum/shared/vote_button.dart';
import 'package:dalgona/firelamp_widgets/widgets/rounded_box.dart';
import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';
import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_meta.dart';
import 'package:dalgona/firelamp_widgets/forum/comment/comment_form.dart';

import 'package:dalgona/firelamp_widgets/forum/shared/files_view.dart';
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
        onError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBox(
      padding: EdgeInsets.all(Space.sm),
      margin: EdgeInsets.only(top: Space.sm, left: Space.sm * (widget.comment.depth - 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(widget.comment.userPhoto, size: 40),
              SizedBox(width: Space.xs),
              CommentMeta(widget.comment),
            ],
          ),
          if (widget.comment.mode == CommentMode.none ||
              widget.comment.mode == CommentMode.reply) ...[
            CommentContent(widget.comment),
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