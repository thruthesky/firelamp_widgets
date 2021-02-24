import 'package:dalgona/firelamp_widgets/widgets/login_first.dart';
import 'package:dalgona/widgets/app.end_drawer.dart';
import 'package:flutter/material.dart';

class LoginFirstScaffold extends StatefulWidget {
  LoginFirstScaffold({this.title = 'Login'});
  final String title;
  @override
  _LoginFirstScaffoldState createState() => _LoginFirstScaffoldState();
}

class _LoginFirstScaffoldState extends State<LoginFirstScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: AppEndDrawer(),
      body: LoginFirst(),
    );
  }
}
