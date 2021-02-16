import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Upload an image.
///
/// It can be used for upload photos for a post, comment, gallery, or even user profile photo.
/// ```dart
/// ApiFile file = await app.imageUpload(onProgress: onProgress);
/// post.files.add(file);
/// final edited = await api.editPost(id: post.id, files: post.files);
/// ```
Future<ApiFile> imageUpload({int quality = 90, Function onProgress}) async {
  /// Ask user
  final re = await Get.bottomSheet(
    Container(
      color: Colors.white,
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.music_note),
                title: Text('take photo from camera'),
                onTap: () => Get.back(result: ImageSource.camera)),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('get photo from gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('cancel'),
              onTap: () => Get.back(result: null),
            ),
          ],
        ),
      ),
    ),
  );
  if (re == null) throw ERROR_IMAGE_NOT_SELECTED;

  /// Pick image
  final picker = ImagePicker();

  final pickedFile = await picker.getImage(source: re);
  if (pickedFile == null) throw ERROR_IMAGE_NOT_SELECTED;

  String localFile = await getAbsoluteTemporaryFilePath(getRandomString() + '.jpeg');
  File file = await FlutterImageCompress.compressAndGetFile(
    pickedFile.path, // source file
    localFile, // target file. Overwrite the source with compressed.
    quality: quality,
  );

  /// Upload
  return await Api.instance.uploadFile(file: file, onProgress: onProgress);
}