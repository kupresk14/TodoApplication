import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/todo_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ToDo extends StatefulWidget {
  ToDo({this.title, this.description, this.uid, this.taskId});

  final title;
  final description;
  final uid;
  final taskId;

  @override
  State<StatefulWidget> createState() => new ToDoOptions();
}

class ToDoOptions extends State<ToDo> {
  TextEditingController todoTitleController = new TextEditingController();
  TextEditingController todoDescController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: <Widget>[
                Text(widget.title),
                FlatButton(
                    child: Text("Read"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ToDoTask(
                                    title: widget.title, description: widget.description,)));
                    }),
                FlatButton(
                    child: Text("Delete"),
                    onPressed: () {
                      Firestore.instance.collection("users").document(widget.uid)
                          .collection('tasks').document(widget.taskId).delete()
                          .whenComplete(() {});
                    }
                ),
                FlatButton(
                    child: Text("Edit"),
                    onPressed: () {
                      showUpdate();
                    }
                ),
              ],
            )
        ));
  }

  showUpdate() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Make changes to task"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title*'),
                controller: todoTitleController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Task Description*'),
                controller: todoDescController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                todoTitleController.clear();
                todoDescController.clear();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Apply'),
              onPressed: () {
                if (todoDescController.text.isNotEmpty && todoTitleController.text.isNotEmpty) {
                  Firestore.instance.collection("users").document(widget.uid).collection("tasks").document(widget.taskId).updateData(
                      {
                        "title": todoTitleController.text,
                        "description": todoDescController.text,
                      }).then((result) =>
                  {
                    Navigator.pop(context),
                    todoTitleController.clear(),
                    todoDescController.clear(),
                  })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),
    );
  }
}



