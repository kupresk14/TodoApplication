import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

///*****************************************************************************
///
/// This is a simple flutter aplication featuring Firebase and Firestore which
/// allows a user to create accounts, sign in, and use a todo list of their own
/// creation. This is only a basic concept!
///
/// Author: Kyler Kupres
/// Date: 3/13/3030
/// Version: v2.0
/// File: todo_task.dart
///
///*****************************************************************************

class ToDoTask extends StatelessWidget{
  ToDoTask({this.title, this.description, this.taskId, this.userId});

  ///Stores the title of the todo task
  final title;

  ///Stores the description of the todo task
  final description;

  ///Stores the taskId of a given task (unique)
  final taskId;

  ///Stores the userId of a given task (unique)
  final userId;

  ///
  /// This is building the Widget / view of a todo task when the Read button
  /// is pressed by the user. It allows them to view the title, description,
  /// choose to go back to the previous screen, or complete the task and go
  /// back to the previous screen.
  ///
  /// Currently, marking a todo as done simply deletes the todo from the list
  /// when pressed.
  ///
  /// Spacing is a bit off but it works as expected
  ///
  ///
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ///This SizedBox is a constant sized box containing the title of
              ///the todo task
              SizedBox(
                width:300,
                child: new Text(description, textScaleFactor: 2.0,),
              ),

              ///This Button is used for the Back button, all it does is returns
              ///the user to the previous screen
              RaisedButton(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textColor: Colors.black,
                  onPressed: () => Navigator.pop(context)
              ),

              ///This button is used to mark an item as complete, it would
              ///generally have more features but it currently deletes the item
              ///from the list and goes back to the previous screen.
              RaisedButton(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Text('Mark as Complete', style: TextStyle(fontWeight: FontWeight.bold)),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textColor: Colors.black,
                  onPressed: () {
                    Firestore.instance.collection("users").document(userId)
                        .collection('tasks').document(taskId).delete()
                        .whenComplete(() {
                      Navigator.pop(context);
                    });
                  }
              )
            ],
          ),
        ),
      );
    }
}

