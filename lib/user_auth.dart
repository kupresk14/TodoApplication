import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

///*****************************************************************************
///
/// This is a simple flutter aplication featuring Firebase and Firestore which
/// allows a user to create accounts, sign in, and use a todo list of their own
/// creation. This is only a basic concept!
///
/// Author: Kyler Kupres
/// Date: 3/13/3030
/// Version: v2.0
/// File: user_auth.dart
///
///*****************************************************************************


abstract class BaseAuth {
  ///Function that handles userSignIn via email and passowrd
  Future<String> userSignIn(String email, String password);

  ///Function that handles userSignUp via email and password
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

  ///Set up a Firebase authentication instance for the user
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///
  /// This function takes an email and a password and checks if Firebase can
  /// successfully sign the user into their account. It will return the user.uid
  /// upon completion and may be null
  ///
  Future<String> userSignIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  ///
  /// This function takes an email and password and checks if Firebase can
  /// successfully sing up a user for an account. It will return the user.uid
  /// upon completion and may also be null
  ///
  Future<String> userSignUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  ///Get the current user of the current instance
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  ///Sign the user out of their Firebase account
  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }

  ///This is not currently used, but would be used to send email verification
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  ///This is not currently used, but would be used to verify email
  Future<bool> verifyEmailCheck() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}