import 'package:dalgona/services/defines.dart';
import 'package:flutter/material.dart';

class LoginFirst extends StatefulWidget {
  @override
  _LoginFirstState createState() => _LoginFirstState();
}

class _LoginFirstState extends State<LoginFirst> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(width: xxl, height: xxl),
          Center(
            child: Text('Login first!!'),
          ),
        ],
      ),
    );
  }
}
