import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/todolist.dart';
import 'package:flutterapp/user_auth.dart';
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
/// File: todo_page.dart
///
///*****************************************************************************

class ToDoList extends StatefulWidget {
  ToDoList({Key key, this.auth, this.uid, this.logoutCheck})
      : super(key: key);

  ///Variable to hold the user Authentication date
  final BaseAuth auth;

  ///Variable to store the user ID
  final uid;

  ///Variable to handle the logoutCheck callback
  final VoidCallback logoutCheck;

  @override
  State<StatefulWidget> createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  ///Controller to handle the title of a todo
  TextEditingController todoTitleController;

  ///Controller to handle the description fo a todo
  TextEditingController todoDescController;

  ///Variable to store the current Firebase User
  FirebaseUser currUser;

  ///This is the initialization of the class and sets up both of the text
  ///controllers as well as gets the current user.
  @override
  void initState() {
    todoTitleController = new TextEditingController();
    todoDescController = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }

  ///
  /// This is the function which builds the main screen of the ToDo list. It has
  /// a logout button in the top right, a title in the top center, and then
  /// shows a list of all of the todo's which are currently in the database for
  /// a user. This is also where the Add button is held and used when a user
  /// wants to add a new todo
  ///
  ///
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        //App title
        title: Text('My Todo List'),
        centerTitle: true,
        actions: <Widget>[
          //Button that is used to control logging out
          new FlatButton(onPressed: signOut, child: new Text('Logout', style: new TextStyle(fontSize: 20.0, color: Colors.black)))
        ],
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("users")
                  .document(widget.uid)
                  .collection('tasks')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new ToDo(
                          title: document['title'],
                          description: document['description'],
                          uid: widget.uid,
                          taskId: document.documentID,
                        );
                      }).toList()
                    );
                }
              },
            )),
      ),
      //Button that is user to control adding a task
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  ///
  /// This function opens up a new Alertdialog which is then used to fill out a
  /// new todo task. It asks the user for the task title, task description, and
  /// then has a cancel and add button which do their respective tasks.
  ///
  /// A todo has a title length of 10 and a desription length of 1000. This will
  /// also catch any odd errors and will throw them via a print statement should
  /// they arrise
  ///
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          children: <Widget>[
            //Title of AlertDialog
            Text("Please fill all fields to create a new task", style: TextStyle(fontWeight: FontWeight.bold),),
            //Handles the input of the task title
            Expanded(
              child: TextField(maxLengthEnforced: true, maxLength: 10,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title:'),
                controller: todoTitleController,
              ),
            ),
            //Handles the input of the task description on multiple lines
            Expanded(
              child: TextField(keyboardType: TextInputType.multiline, maxLines: 5, maxLengthEnforced: true, maxLength: 1000,
                decoration: InputDecoration(labelText: 'Task Description:'),
                controller: todoDescController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          //This sets up the cancel button of the add screen
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                todoTitleController.clear();
                todoDescController.clear();
                Navigator.pop(context);
              }),
          //This sets up the add button of the add screen. Controls length again
          //just to be safe when adding to the database. Throws an error if not
          //completed correctly
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (todoDescController.text.isNotEmpty &&
                    todoTitleController.text.isNotEmpty) {
                  if (todoTitleController.text.length <= 10 && todoDescController.text.length <= 1000) {
                    Firestore.instance
                        .collection("users")
                        .document(currUser.uid)
                        .collection("tasks")
                        .add({
                      "title": todoTitleController.text,
                      "description": todoDescController.text,
                    })
                        .then((result) =>
                    {
                      Navigator.pop(context),
                      todoTitleController.clear(),
                      todoDescController.clear(),
                    })
                        .catchError((err) => print(err));
                  }
                  else {
                    print("Title overflow");
                  }
                }
              })
        ],
      ),
    );
  }

  ///This function calls the signOut() function from the authentication data and
  ///will throw an error if not properly completed.
  signOut() async {
    try{
      await widget.auth.signOut();
      widget.logoutCheck();
    } catch(e) {
      print(e);
    }
  }

  ///This function gets the current user from the current Firebase instance
  void getCurrentUser() async {
    currUser = await FirebaseAuth.instance.currentUser();
  }
}



