import 'package:flutter/material.dart';
import 'package:flutterapp/user_auth.dart';

///*****************************************************************************
///
/// This is a simple flutter aplication featuring Firebase and Firestore which
/// allows a user to create accounts, sign in, and use a todo list of their own
/// creation. This is only a basic concept!
///
/// Author: Kyler Kupres
/// Date: 3/13/3030
/// Version: v2.0
/// File: login_page.dart
///
///*****************************************************************************

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCheck});

  ///Variable to store authentication data about a user
  final BaseAuth auth;

  ///A callback which is used to check login status (always a void function)
  final VoidCallback loginCheck;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

///
/// This is the _LoginPageState class which is used to setup and handle the
/// login structure of the first screen.
///
class _LoginPageState extends State<LoginPage> {

  ///Get a key related to the current session
  final _formKey = new GlobalKey<FormState>();

  ///Boolean to determine loading status
  bool _isLoading = false;

  ///Boolean to determine if user wants to login or create an account
  bool _isLoginForm = false;

  ///String to hold the user's email account
  String _email = "";

  ///String to hold the user's password
  String _password = "";

  ///String to hold error messages should they arrise
  String _errorMessage = "";

  ///This builds the login screen by calling showForm() and the
  ///showCircularProgress() loading widget. These are loaded into
  ///a Stack
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            showForm(),
            showCircularProgress(),
          ],
        )
    );
  }

  ///This function returns a Widget which is that of a circular loading
  ///icon used for times when the app is loading.
  Widget showCircularProgress(){
    if(_isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  ///Setting the inital state of the application and variables upon load
  @override
  void initState(){
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
  }

  ///This function returns the notebook logo that is shown when the application
  ///is on the login screen. Uses an image asset and has controlling parameters
  Widget showLogo(){
    return new Hero(
      tag: 'TodoImage',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 120,
          child: Image.asset('assets/notebook.png'),
        ),
      ),
    );
  }

  ///Show the email input to the user, but also controls error checking
  ///where the user did not enter anything.
  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.black,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  ///Show the password input box on the screen and also controlls and error
  ///where the user did not input anything in the password box.
  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.black,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  ///Show button to either log in or Create account on the screen, it is changed
  ///when the user clicks on the "log in", or "create an account" text below
  ///the password box on the screen.
  Widget showMainButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.black,
            //Controlling text / button functionality
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  ///Show the other options if the button choices are switched on the screen,
  ///sign in vs, create an account
  Widget showOtherButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: changeSelection);
  }

  ///Change the selection of the options on the screen
  void changeSelection(){
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  ///Reset the forms so that they do not display a string
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  ///Check if form is valid before perform login or signup, and if it is it will
  ///save that form, otherwise it returns false
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  ///This function is used to show an error message when one arrives. It will
  ///create new text that pops up so that the user can read it.
  ///
  /// The _errorMessage String is what controls this as there is a check in
  /// place if the variable does not meet certain standards.
  ///
  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  ///
  /// This is the funtion that handles logging in / creation of accounts by
  /// using the auth variable from the user_auth.dart class.
  ///
  /// If validateAndSave() is true, it will try to log a user in if _isLoginForm
  /// is true, otherwise it will assume that the user it creating an account
  /// and will call the sign up method. It performs a login check when the
  /// conditions are met and will give any errors to _errorMessage() so that
  /// they can be displayed properly to the user.
  ///
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if(validateAndSave()){
      String userId = "";
      try{
        if(_isLoginForm){
          userId = await widget.auth.userSignIn(_email, _password);
        }
        else{
          userId = await widget.auth.userSignUp(_email, _password);
        }
        setState(() {
          _isLoading = false;
        });

        if(userId.length > 0 && userId != null && _isLoginForm){
          widget.loginCheck();
        }
      }
      catch(e){
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
          _formKey.currentState.reset();
        });
      }
    }
  }

  ///
  /// This function sets up the entire view of the login screen, it calls each
  /// of the functions above to set up the listview of the login screen.
  ///
  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              //Display the logo
              showLogo(),
              //Display the email input line
              showEmailInput(),
              //Display the password input line
              showPasswordInput(),
              //Display the login/create account button
              showMainButton(),
              //Make sure button switches text when needed
              showOtherButton(),
              //Load the error handling of the login screen
              showErrorMessage(),
            ],
          ),
        ));
  }

}

