import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';

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

/// Returns absolute file path from the relative path.
/// [path] must include the file extension.
/// @example
/// ``` dart
/// localFilePath('photo/baby.jpg');
/// ```
// Future<String> getAbsoluteTemporaryFilePath(String relativePath) async {
//   var directory = await getTemporaryDirectory();
//   return p.join(directory.path, relativePath);
// }

/// Returns a random string
///
///
// String getRandomString({int len = 16, String prefix}) {
//   const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
//   var t = '';
//   for (var i = 0; i < len; i++) {
//     t += charset[(Random().nextInt(charset.length))];
//   }
//   if (prefix != null && prefix.isNotEmpty) t = prefix + t;
//   return t;
// }

error(dynamic e, [String message]) {
  print('=> error(e): ');
  print(e);
  print('=> e.runtimeType: ${e.runtimeType}');

  String title = 'Ooh'.tr;
  String msg = '';

  /// e is title, message is String
  if (message != null) {
    title = e;
    msg = message;
  } else if (e is String) {
    /// Is error string? If error string begins with `ERROR_`, then it might be PHP error or client error.
    if (e.indexOf('ERROR_') == 0) {
      // if (e == ERROR_PROFILE_READY) return onErrorProfileReady();
      // 콜론(:) 다음에 추가적인 에러 메시지가 있을 수 있다.
      if (e.indexOf(':') > 0) {
        List<String> arr = e.split(':');
        msg = arr[0].tr + ' : ' + arr[1];
      } else {
        msg = e.tr;
      }
    } else {
      msg = e;
    }
  } else if (e is DioError) {
    // print("Got dio error on error(e)");
    // print(e.error);
    msg = e.message;

    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      // print(e.response.data);
      // print(e.response.headers);
      // print(e.response.request);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      // print(e.request);
      // print(e.message);
    }
  } else if (e is FirebaseException) {
    // print("Got firebase error on error(e)");
    msg = "Firebase Exception: ${e.code}, ${e.message}";
  } else {
    /// other errors.
    // print("Got unknown error on error(e)");
    msg = "Unknown error";
  }

  // print('error msg: $msg');
  Get.snackbar(
    title,
    msg,
    animationDuration: Duration(milliseconds: 700),
  );
}

/// 예/아니오를 선택하게 하는 다이얼로그를 표시한다.
///
/// 예를 선택하면 true, 아니오를 선택하면 false 를 리턴한다.
Future<bool> confirm(String title, String message) async {
  return await showDialog(
    context: Get.context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('yes'.tr),
              ),
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('no'.tr),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Future alert(String message) async {
  await Get.defaultDialog(
    title: '알림',
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    textConfirm: '확인',
    onConfirm: () => Get.back(),
    confirmTextColor: Colors.white,
  );
}
