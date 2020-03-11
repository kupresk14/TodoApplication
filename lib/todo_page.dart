import 'package:flutter/material.dart';
//import 'package:flutterapp/todolist.dart';
//import 'package:flutterapp/user_auth.dart';
//
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/user_auth.dart';

class ToDoList extends StatefulWidget {
  ToDoList({Key key, this.auth, this.userId, this.logoutCheck})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCheck;
  final String userId;

  @override
  State<StatefulWidget> createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList> {
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
}


