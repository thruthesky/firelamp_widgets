import 'package:dalgona/firelamp_widgets/forum/shared/files_form.dart';
import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/functions.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({
    Key key,
    @required this.post,
    this.parent,
    this.comment,
    @required this.forum,
    this.onError,
  }) : super(key: key);

  /// post of the comment
  final ApiPost post;
  final ApiComment parent;
  final ApiComment comment;
  final ApiForum forum;
  final Function onError;

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final content = TextEditingController();

  /// [comment] to create or update
  ///
  /// Attention, the reason why it has a copy in state class is because
  /// when the app does hot reload(in development mode), the state disappears
  /// (like when file is uploaded and it disappears on hot reload).
  ApiComment comment;

  bool loading = false;

  bool get canSubmit => (content.text != '' || comment.files.isNotEmpty) && !loading;
  double percentage = 0;

  // file upload
  onImageIconPressed() async {
    try {
      final file =
          await imageUpload(quality: 95, onProgress: (p) => setState(() => percentage = p));
      // print('file upload success: $file');
      percentage = 0;
      comment.files.add(file);
      setState(() => null);
    } catch (e) {
      if (e == ERROR_IMAGE_NOT_SELECTED) {
      } else {
        onError(e);
      }
    }
  }

  // form submit
  onFormSubmit() async {
    if (loading) return;
    setState(() => loading = true);
    FocusScope.of(context).requestFocus(FocusNode());
    if (Api.instance.notLoggedIn) return onError("Login First");

    try {
      final editedComment = await Api.instance.editComment(
        content: content.text,
        parent: widget.parent,
        comment: comment,
        post: widget.post,
        files: comment.files,
      );

      widget.post.insertOrUpdateComment(editedComment);
      content.text = '';
      comment.files = [];
      loading = false;
      if (widget.parent != null) widget.parent.mode = CommentMode.none;
      if (widget.comment != null) comment.mode = CommentMode.none;
      setState(() => null);
      widget.forum.render();
      // print('editeComment..: $editedComment');
    } catch (e) {
      setState(() => loading = false);
      onError(e);
    }
  }

  onError(dynamic e) {
    if (widget.onError != null) {
      widget.onError(e);
    }
  }

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
    content.text = comment.commentContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: Space.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                alignment: Alignment.center,
                icon: Icon(Icons.camera_alt, color: Colors.black),
                onPressed: onImageIconPressed,
              ),
              Expanded(
                child: TextFormField(
                  controller: content,
                  onChanged: (v) => setState(() => null),
                  // expands: true,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(Space.sm),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              if (loading)
                Padding(padding: EdgeInsets.all(Space.sm), child: Spinner(centered: false, size: 18)),
              if (canSubmit)
                IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.send_rounded),
                  onPressed: onFormSubmit,
                )
            ],
          ),
          FilesForm(postOrComment: comment),
        ],
      ),
    );
  }
}
