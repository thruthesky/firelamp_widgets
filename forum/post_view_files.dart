import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/misc/cache_image.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';

class PostViewFiles extends StatelessWidget {
  const PostViewFiles({
    Key key,
    this.postOrComment,
  }) : super(key: key);

  final dynamic postOrComment;

  @override
  Widget build(BuildContext context) {
    if (postOrComment.files.length == 0) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Space.sm),
        Text(
          'Attached files',
          style: TextStyle(color: Colors.grey, fontSize: Space.xsm),
        ),
        Divider(),
        for (ApiFile file in postOrComment.files) CacheImage(file.url),
      ],
    );
  }
}