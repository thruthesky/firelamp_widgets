import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';

import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/functions.dart';
import 'package:dalgona/firelamp_widgets/forum/files_form.dart';

import 'package:dalgona/firelamp_widgets/misc/spinner.dart';

class PostForm extends StatefulWidget {
  PostForm(this.forum);

  final ApiForum forum;
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final title = TextEditingController();
  final content = TextEditingController();
  double percentage = 0;
  bool loading = false;
  ApiPost post;
  List<String> categories;
  String category;

  InputDecoration _inputDecoration = InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.all(Space.sm),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(10.0),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    // print('_PostFormState::initState()');
    post = widget.forum.postInEdit;
    title.text = post.postTitle;
    content.text = post.postContent;
  }

  @override
  Widget build(BuildContext context) {
    ApiForum forum = widget.forum;

    if (forum.postInEdit == null) return SizedBox.shrink();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Space.sm),
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Space.xs, bottom: Space.xs),
              child: Text('title'.tr),
            ),
            TextFormField(
              controller: title,
              decoration: _inputDecoration,
            ),
            Padding(
              padding: EdgeInsets.only(top: Space.md, bottom: Space.xs),
              child: Text('content'.tr),
            ),
            TextFormField(
              controller: content,
              minLines: 5,
              maxLines: 15,
              decoration: _inputDecoration,
            ),
            FilesForm(postOrComment: forum.postInEdit),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Upload Button
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    try {
                      final file = await imageUpload(
                          quality: 95, onProgress: (p) => setState(() => percentage = p));
                      // print('file upload success: $file');
                      percentage = 0;
                      post.files.add(file);
                      setState(() => null);
                    } catch (e) {
                      if (e == ERROR_IMAGE_NOT_SELECTED) {
                      } else {
                        error(e);
                      }
                    }
                  },
                ),
                if (percentage > 0)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: Space.sm),
                      child: LinearProgressIndicator(value: percentage),
                    ),
                  ),

                /// Submit button
                if (!loading)
                  Row(
                    children: [
                      FlatButton(
                        child: loading ? Spinner() : Text('Submit'),
                        color: loading ? Colors.grey : Colors.green[300],
                        onPressed: () async {
                          if (loading) return;
                          setState(() => loading = true);

                          if (Api.instance.notLoggedIn) return error("Login First");
                          try {
                            final editedPost = await Api.instance.editPost(
                              id: post.id,
                              category: forum.category,
                              title: title.text,
                              content: content.text,
                              files: post.files,
                            );
                            forum.insertOrUpdatePost(editedPost);
                            setState(() => loading = false);
                            // reset();
                          } catch (e) {
                            setState(() => loading = false);
                            error(e);
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}