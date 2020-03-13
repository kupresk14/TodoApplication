import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoTask extends StatelessWidget{
  ToDoTask({this.title, this.description});

  final title;
  final description;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(description),
              RaisedButton(
                  child: Text('Back'),
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textColor: Colors.black,
                  onPressed: () => Navigator.pop(context)),
            ],
          ),

        ),
      );
    }
}

