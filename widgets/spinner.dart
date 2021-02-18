import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({Key key, this.size = 24, this.loading = true, this.centered = true})
      : super(key: key);

  final double size;
  final bool loading;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    if (loading == false) return SizedBox.shrink();
    final spinner = SizedBox(
      width: size,
      height: size,
      child: Platform.isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator(),
    );

    return centered ? Center(child: spinner) : spinner;
  }
}
