import 'package:cached_network_image/cached_network_image.dart';
import './spinner.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  CachedImage(
    this.url, {
    this.width,
    this.height,
  });
  final String url;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          Icons.error,
          size: 64,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Spinner(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: height,
    );
  }
}
