import 'package:dalgona/firelamp_widgets/defines.dart';
import 'package:dalgona/firelamp_widgets/widgets/spinner.dart';
import 'package:firelamp/firelamp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// ...

class AppPhotoViewer extends StatefulWidget {
  AppPhotoViewer(this.files, {this.initialIndex});

  final List<ApiFile> files;
  final int initialIndex;

  @override
  _AppPhotoViewerState createState() => _AppPhotoViewerState();
}

class _AppPhotoViewerState extends State<AppPhotoViewer> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialIndex);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            child: PhotoViewGallery.builder(
              itemCount: widget.files.length,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int i) {
                return PhotoViewGalleryPageOptions(
                  minScale: .3,
                  imageProvider: NetworkImage(widget.files[i].url),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.files[i].idx),
                );
              },
              loadingBuilder: (context, event) => Center(
                child: Spinner(valueColor: Colors.white),
              ),
              pageController: _controller,
              // onPageChanged: onPageChanged,
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.close_rounded, color: Colors.redAccent, size: Space.xl),
                onPressed: () => Get.back()),
          )
        ],
      ),
    );
  }
}
