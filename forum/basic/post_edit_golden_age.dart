import 'package:dalgona/firelamp_widgets/widgets/circle_icon.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Basic(sample) widget for creating a post
///
/// ```dart
/// ForumBasicPostEditGoldenAge(
///   category: 'qna',
///   onCancel: () {
///     print('cancel:');
///   },
///   onSuccess: (post) {
///     print('success: $post');
///   },
///   onError: (e) {
///     print('error: $e');
///     app.error(e);
///   },
/// ),
/// ```dart
///
class ForumBasicPostEditGoldenAge extends StatefulWidget {
  ForumBasicPostEditGoldenAge({
    this.category,
    this.post,
    @required this.onCancel,
    @required this.onSubmit,
    @required this.onError,
  });
  final String category;
  final Function onCancel;
  final Function onSubmit;
  final Function onError;
  final ApiPost post;

  @override
  _ForumBasicPostEditGoldenAgeState createState() => _ForumBasicPostEditGoldenAgeState();
}

class _ForumBasicPostEditGoldenAgeState extends State<ForumBasicPostEditGoldenAge> {
  ApiPost post;
  @override
  void initState() {
    super.initState();
    if (widget.post == null)
      post = ApiPost(category: widget.category);
    else
      post = widget.post;
  }

  bool get canSubmit {
    if (post.postTitle == '') return false;
    if (post.postContent == '' && post.files.length == 0) return false;
    return true;
  }

  uploadImage(ImageSource source) async {
    try {
      final res = await Api.instance.takeUploadFile(
          source: source,
          onProgress: (p) {
            print('p: $p');
          });
      post.files.add(res);
      setState(() {});
      print('success: $res');
    } catch (e) {
      widget.onError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return post == null
        ? Spinner()
        : Container(
            child: Column(
            children: [
              TextFormField(
                initialValue: post.postTitle,
                onChanged: (text) => setState(() => post.postTitle = text),
                decoration: InputDecoration(labelText: '제목을 입력하세요.'),
              ),
              TextFormField(
                initialValue: post.postContent,
                onChanged: (text) => setState(() => post.postContent = text),
                decoration: InputDecoration(labelText: '내용을 입력하세요.'),
                maxLines: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.photo_camera),
                          Text('촬영하기', style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      onPressed: () => uploadImage(ImageSource.camera)),
                  FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.collections),
                          Text('사진가져오기', style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      onPressed: () => uploadImage(ImageSource.gallery)),
                ],
              ),
              Container(
                width: 300,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    '수정하기',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onPressed: () => widget.onSubmit(post),
                ),
              ),
              if (post.files.length > 0)
                Container(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      for (final file in post.files)
                        Stack(
                          children: [
                            Image.network(
                              file.thumbnailUrl,
                              width: 100,
                              height: 100,
                            ),
                            CircleIcon(
                                icon: Icon(Icons.delete),
                                backgroundColor: Colors.grey[800],
                                onPressed: () async {
                                  print('delete: ${file.id}');
                                  try {
                                    await Api.instance.deleteFile(file.id, postOrComment: post);
                                    print('delete: success');
                                    setState(() {});
                                  } catch (e) {
                                    widget.onError(e);
                                  }
                                }),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ));
  }
}
