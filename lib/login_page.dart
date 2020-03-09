import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isLoginForm = false;

  String _email;
  String _password;
  String _errorMessage;

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Login Test"),
//        ),
        body: Stack(
          children: <Widget>[
            showForm(),
            showCircularProgress(),
          ],
        ));
  }

  Widget showCircularProgress(){
    if(_isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showLogo(){
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  ///Show the email input
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
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  ///Show the password input box on the screen
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
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  ///Show button to either log in or Create account on the screen
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
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
        ));
  }

  ///Show the other options if the button choices are switched on the screen
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

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

//  Widget showErrorMessage() {
//    if (_errorMessage.length > 0 && _errorMessage != null) {
//      return new Text(
//        _errorMessage,
//        style: TextStyle(
//            fontSize: 13.0,
//            color: Colors.red,
//            height: 1.0,
//            fontWeight: FontWeight.w300),
//      );
//    } else {
//      return new Container(
//        height: 0.0,
//      );
//    }
//  }

  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showMainButton(),
              showOtherButton(),
              //showErrorMessage(), //Fix this later if desired
            ],
          ),
        ));
  }
}


