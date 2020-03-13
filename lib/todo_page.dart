import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/todolist.dart';
import 'package:flutterapp/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoList extends StatefulWidget {
  ToDoList({Key key, this.auth, this.uid, this.logoutCheck})
      : super(key: key);

  final BaseAuth auth;
  final uid;
  final VoidCallback logoutCheck;

  @override
  State<StatefulWidget> createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  TextEditingController todoTitleController;
  TextEditingController todoDescController;
  FirebaseUser currUser;

  @override
  void initState() {
    todoTitleController = new TextEditingController();
    todoDescController = new TextEditingController();
    this.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo List'),
        centerTitle: true,
        actions: <Widget>[
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to create a new task"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title'),
                controller: todoTitleController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Task Description'),
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
              child: Text('Add'),
              onPressed: () {
                if (todoDescController.text.isNotEmpty &&
                    todoTitleController.text.isNotEmpty) {
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
              })
        ],
      ),
    );
  }

  signOut() async {
    try{
      await widget.auth.signOut();
      widget.logoutCheck();
    } catch(e) {
      print(e);
    }
  }

  void getCurrentUser() async {
    currUser = await FirebaseAuth.instance.currentUser();
  }
}



