import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostEditBasic extends StatefulWidget {
  PostEditBasic();

  @override
  _PostEditBasicState createState() => _PostEditBasicState();
}

class _PostEditBasicState extends State<PostEditBasic> {
  ApiPost post = ApiPost();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      setState(() {});
    });
    contentController.addListener(() {
      setState(() {});
    });
  }

  bool get canSubmit {
    if (titleController.text == '') return false;
    if (contentController.text == '' && post.files.length == 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TextField(
          controller: titleController,
        ),
        TextField(
          controller: contentController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {},
            ),
            RaisedButton(
              onPressed: canSubmit ? () async {} : null,
              child: Text('전송'),
            )
          ],
        )
      ],
    ));
  }
}
