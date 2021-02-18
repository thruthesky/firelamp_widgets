import 'package:dalgona/widgets/image.cache.dart';
import 'package:flutter/material.dart';


class UserAvatar extends StatelessWidget {
  UserAvatar(this.url, {this.size = 48, this.onTap});
  final String url;
  final double size;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    // print('url: $url');
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        child: url == null || url == ''
            ? Icon(Icons.person)
            : ClipOval(
                child: CachedImage(url),
              ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
          boxShadow: [
            BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 2.0),
          ],
        ),
      ),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
    );
  }
}
