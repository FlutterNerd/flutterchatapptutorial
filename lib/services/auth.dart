import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';
import 'package:flutterchatapptutorial/services/database.dart';
import 'package:flutterchatapptutorial/views/home.dart';
import 'package:flutterchatapptutorial/views/signin.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //
  getCurrentUser() async {
    return _auth.currentUser;
  }

  // sign in function

  signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    User user = userCredential.user;

    SharedPreferenceHelper().saveUserEmail(user.email);
    SharedPreferenceHelper().saveIsLoggedIn(true);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  // sign up function & save data to shared preference
  signUpWithEmailAndPassword(String username, String email, String password,
      BuildContext context) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User user = userCredential.user;

    SharedPreferenceHelper().saveUserEmail(user.email);
    SharedPreferenceHelper().saveIsLoggedIn(true);

    DatabaseMethods().uploadUserInfo(user.email, username).then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()))
        });
  }

  // sign out

  signOut(BuildContext context) {
    _auth.signOut();
    SharedPreferenceHelper().saveIsLoggedIn(false);
    SharedPreferenceHelper().saveUserEmail("");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }
}
