import 'package:dalgona/firelamp_widgets/widgets/image.cache.dart';
import 'package:dalgona/firelamp_widgets/widgets/app_photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:firelamp/firelamp.dart';
import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:get/get.dart';

class FilesView extends StatelessWidget {
  const FilesView({
    Key key,
    this.postOrComment,
  }) : super(key: key);

  final dynamic postOrComment;

  onImageTap(int idx) {
    final i = postOrComment.files.indexWhere((file) => file.idx == idx);
    Get.dialog(AppPhotoViewer(postOrComment.files, initialIndex: i));
  }

  @override
  Widget build(BuildContext context) {
    if (postOrComment.files.length == 0) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Space.xsm),
        Text(
          'Attached files',
          style: TextStyle(color: Colors.grey, fontSize: Space.xsm),
        ),
        Divider(),
        GridView.count(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 8.0,
          children: [
            for (ApiFile file in postOrComment.files)
              ClipRRect(
                child: GestureDetector(
                  child: CachedImage(file.url),
                  onTap: () => onImageTap(file.idx),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
          ],
        ),
        // SizedBox(height: Space.md),
      ],
    );
  }
}
