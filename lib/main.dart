import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyTaskApp());

class MyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'ToDo Task App',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new LoginPage()
    );
  }
}

