import 'package:flutter/material.dart';
import 'package:flutterapp/user_auth.dart';
import 'package:flutterapp/page_check.dart';

void main() => runApp(new MyTaskApp());

class MyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'ToDo Task App',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new PageCheck(auth: new Authentication()));
  }
}

