import 'package:flutter/material.dart';
import 'package:flutterapp/user_auth.dart';
import 'package:flutterapp/page_check.dart';
import 'package:flutterapp/todo_task.dart';
import 'package:flutterapp/todo_page.dart';

///*****************************************************************************
///
/// This is a simple flutter aplication featuring Firebase and Firestore which
/// allows a user to create accounts, sign in, and use a todo list of their own
/// creation. This is only a basic concept!
///
/// Author: Kyler Kupres
/// Date: 3/13/3030
/// Version: v2.0
/// File: main.dart
///
///*****************************************************************************

void main(){
  //Run a new instance of the MyTaskApp()
  runApp(new MyTaskApp());
}

///This is the inital setup of the todo application.
class MyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Return a MaterialApp with a name, theme, and homepage
    return new MaterialApp(
        title: 'ToDo Task App',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new PageCheck(auth: new Authentication()),
        //These routes are hooked up so that the application knows
        //where to jump to when Navigation elements are used
        routes: <String, WidgetBuilder>{
          '/task':(BuildContext context) => ToDoTask(title: 'Task'),
          '/home':(BuildContext context) => ToDoList(),
        },);
  }
}


