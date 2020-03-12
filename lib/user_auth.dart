import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


abstract class BaseAuth {
  Future<String> userSignIn(String email, String password);

  Future<String> userSignUp(String email, String password);

  ///Get the current user of the application
  Future<FirebaseUser> getCurrentUser();

  ///Function that will send an email verification to the email that a user
  ///wants to register under
  Future<void> sendEmailVerification();

  ///Function that controls signing out of the app
  Future<void> signOut();

  ///Function to tell if a user has verfied their email or not
  Future<bool> verifyEmailCheck();

}

class Authentication implements BaseAuth{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> userSignIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> userSignUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> verifyEmailCheck() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}