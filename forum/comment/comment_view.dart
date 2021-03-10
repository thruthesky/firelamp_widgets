import 'package:dalgona/firelamp_widgets/forum/comment/comment_content.dart';
import 'package:dalgona/firelamp_widgets/widgets/popup_button.dart';
import 'package:dalgona/firelamp_widgets/forum/shared/vote_buttons.dart';
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
    this.onError,
    @required this.forum,
    this.onCommentEditSuccess,
    this.onCommentDeleteSuccess,
  }) : super(key: key);

  final ApiComment comment;
  final ApiPost post;
  final ApiForum forum;
  final Function onError;
  final Function onCommentEditSuccess;
  final Function onCommentDeleteSuccess;

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
        await Api.instance.commentDelete(widget.comment, widget.post);
        if (widget.onCommentDeleteSuccess != null) widget.onCommentDeleteSuccess();
        widget.forum.render();
      } catch (e) {
        if (widget.onError != null) {
          widget.onError(e);
        }
      }
    }
  }

  bool get canCancel =>
      widget.comment.mode == CommentMode.reply || widget.comment.mode == CommentMode.edit;

  @override
  Widget build(BuildContext context) {
    return widget.comment.isDeleted
        ? SizedBox.shrink()
        : RoundedBox(
            padding: EdgeInsets.all(Space.sm),
            margin: EdgeInsets.only(top: Space.sm, left: Space.sm * (widget.comment.depth - 1)),
            boxColor: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserAvatar(widget.comment.user.photoUrl, size: 40),
                    SizedBox(width: Space.xs),
                    CommentMeta(widget.comment),
                  ],
                ),
                if (widget.comment.mode == CommentMode.none ||
                    widget.comment.mode == CommentMode.reply) ...[
                  CommentContent(widget.comment),
                  FilesView(postOrComment: widget.comment),
                  Divider(height: Space.sm, thickness: 1.3),
                  Row(children: [
                    IconButton(
                      // child: Text(widget.comment.mode == CommentMode.reply ? 'Cancel' : 'Reply'),
                      icon: Icon(widget.comment.mode == CommentMode.reply ? Icons.close : Icons.reply_rounded),
                      onPressed: () {
                        setState(() {
                          widget.comment.mode = widget.comment.mode == CommentMode.reply
                              ? CommentMode.none
                              : CommentMode.reply;
                        });
                      },
                    ),
                    VoteButtons(
                      postOrComment: widget.comment,
                      showLike: widget.forum.showLike,
                      showDislike: widget.forum.showDislike,
                      onError: widget.onError,
                    ),
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
                    forum: widget.forum,
                    onSuccess: widget.onCommentEditSuccess,
                  ),
                if (widget.comment.mode == CommentMode.edit)
                  CommentForm(
                    comment: widget.comment,
                    post: widget.post,
                    forum: widget.forum,
                    onSuccess: widget.onCommentEditSuccess,
                  ),
                // if (canCancel)
                //   IconButton(
                //     icon: Icon(Icons.close, color: Colors.redAccent),
                //     onPressed: () {
                //       setState(() {
                //         widget.comment.mode = CommentMode.none;
                //       });
                //     },
                //   ),
              ],
            ),
          );
  }
}
