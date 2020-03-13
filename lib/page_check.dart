import 'package:flutter/material.dart';
import 'package:flutterapp/login_page.dart';
import 'package:flutterapp/user_auth.dart';
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
/// File: page_check.dart
///
///*****************************************************************************


///This is an enum which determines login status. It is either not determined,
///not logged in, or logged in.
enum LogStatus{
  NOT_DET,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class PageCheck extends StatefulWidget{
  PageCheck({this.auth});

  ///Variable to store authentication data
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _PageState();
}

class _PageState extends State<PageCheck> {

  ///Set the enum logStatus to NOT_DET initially
  LogStatus logStatus = LogStatus.NOT_DET;

  ///String which houses the user ID
  String _userId = "";

  ///When first loaded, it checks for the current user and will set it's state
  ///according to is the id is null or not. It switches between NOT_LOGGED_IN
  ///and LOGGED_IN
  @override
  void initState(){
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null){
          _userId = user?.uid;
        }
        logStatus = user?.uid == null ? LogStatus.NOT_LOGGED_IN : LogStatus.LOGGED_IN;
      });
    });
  }

  ///This is the void callback which is used to determine if a user is actually
  ///logged in to the database or not.
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

  ///This is the void callback which is used to determine if as user is actually
  ///logged out of the database or not
  void logoutCheck(){
    setState(() {
      logStatus = LogStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  ///This function is used to return a circular progress indicator when called.
  ///Used to control loading animations.
  Widget waitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  ///
  /// This is used to handle which pages show up upon Authentication() call. If
  /// the logstatus is NOT_LOGGED_IN it will return a new LoginPage() which will
  /// stay there until the user logs in to an acccount. Used the auth variable
  /// and the loginCheck callback
  ///
  /// When NOT_DET it will show the loading circle to let the user know it is
  /// loading.
  ///
  /// When LOGGED_IN it will show a new instance of the ToDoList which is given
  /// the auth variable, the _userId variable and the logoutCheck callback
  ///
  /// The default is returning the waiting screen when nothing is going on.
  ///
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
            uid: _userId,
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

