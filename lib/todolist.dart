import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/todo_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///*****************************************************************************
///
/// This is a simple flutter aplication featuring Firebase and Firestore which
/// allows a user to create accounts, sign in, and use a todo list of their own
/// creation. This is only a basic concept!
///
/// Author: Kyler Kupres
/// Date: 3/13/3030
/// Version: v2.0
/// File: todolist.dart
///
///*****************************************************************************


class ToDo extends StatefulWidget {
  ToDo({this.title, this.description, this.uid, this.taskId});

  ///Stores the title of the todo task
  final title;

  ///Stores the description of the todo task
  final description;

  ///Stores the user Id of a user (unique)
  final uid;

  ///Stores the task Id of a task (unique)
  final taskId;

  @override
  State<StatefulWidget> createState() => new ToDoOptions();
}

class ToDoOptions extends State<ToDo> {
  ///Text controller for a todo title
  TextEditingController todoTitleController = new TextEditingController();
  ///Text controller for a todo description
  TextEditingController todoDescController = new TextEditingController();

  ///
  /// This builds a widget which displays the list of todo's that are available
  /// within the Firestore database. It will return as many as there are.
  ///
  /// This also shows a "Read","Delete", and "Edit" button. The Read button
  /// allows a user to read the content of a todo as well as mark it completed.
  /// The Delete button simply deletes the todo from the list of others. The
  /// edit button is used to change the content of a todo and saves any changes
  /// upon submittion.
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0,left: 20.0),
            child: Row(
              children: <Widget>[
                //Constant size box for the title of a todo
                SizedBox(
                  width:80.0,
                  child: new Text(widget.title.toString()),
                ),
                ///Read button
                FlatButton(
                  padding: const EdgeInsets.only(left: 50),
                    child: Text("Read", style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ToDoTask(
                                    title: widget.title, description: widget.description, taskId: widget.taskId, userId: widget.uid,)));
                    }),
                ///Delete button
                FlatButton(
                    padding: const EdgeInsets.only(left:10),
                    child: Text("Delete",style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Firestore.instance.collection("users").document(widget.uid)
                          .collection('tasks').document(widget.taskId).delete()
                          .whenComplete(() {});
                    }
                ),
                ///Edit button
                FlatButton(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text("Edit",style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      showUpdate();
                    }
                ),
              ],
            )
        ));
  }

  ///
  /// This section is for the editing of a todo task. It opens a new window
  /// similar to the create screen where a user can input new information
  /// that they would like to have in the given todo.
  ///
  /// Max length is 10 for title and 1000 for description content
  ///
  showUpdate() async {
    await showDialog<String>(
      context: context,
      ///Creating a new window allowing new inputs
      child: AlertDialog(
        contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 100),
        content: Column(
          children: <Widget>[
            Text("Make changes to task", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: TextField(maxLengthEnforced: true, maxLength: 10,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title:'),
                controller: todoTitleController,
              ),
            ),
            Expanded(
              child: TextField(keyboardType: TextInputType.multiline, maxLines: 5, maxLengthEnforced: true, maxLength: 1000,
                decoration: InputDecoration(labelText: 'Task Description:'),
                controller: todoDescController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          ///Cancel button for the edit window
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                todoTitleController.clear();
                todoDescController.clear();
                Navigator.pop(context);
              }),
          ///Apply button for the edit window
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



