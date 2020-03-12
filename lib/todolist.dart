import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/todo_task.dart';


class ToDo extends StatelessWidget {
  ToDo({this.title, this.description});

  final title;
  final description;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(title),
                FlatButton(
                    child: Text("Read"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ToDoTask(title: title, description: description)));
                    }),
              ],
            )
        ));
  }
}


