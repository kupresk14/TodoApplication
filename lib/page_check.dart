import 'package:flutter/material.dart';
import 'package:flutterapp/login_page.dart';
import 'package:flutterapp/user_auth.dart';
import 'package:flutterapp/todo_page.dart';

enum LogStatus{
  NOT_DET,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class PageCheck extends StatefulWidget{
  PageCheck({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _PageState();

}

class _PageState extends State<PageCheck> {

  LogStatus logStatus = LogStatus.NOT_DET;
  String _userId = "";

  @override
  void initState(){
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null){
          _userId = user?.uid;
        }
        logStatus = user?.uid == null ? LogStatus.LOGGED_IN : LogStatus.NOT_LOGGED_IN;
      });
    });
  }

  void loginCheck() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      logStatus = LogStatus.LOGGED_IN;
    });
  }

  void logoutCheck(){
    setState(() {
      logStatus = LogStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget waitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(logStatus){
      case LogStatus.NOT_DET:
        return waitingScreen();
        break;
      case LogStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCheck: loginCheck,
        );
        break;
      case LogStatus.LOGGED_IN:
        if(_userId.length > 0 && _userId != null){
          return new ToDoList(
            auth: widget.auth,
            userId: _userId,
            logoutCheck: logoutCheck,
          );
        }
        else {
          return waitingScreen();
        }
        break;

        default:
          return waitingScreen();
    }
  }

}

