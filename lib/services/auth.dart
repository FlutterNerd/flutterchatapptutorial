import 'package:cloud_firestore/cloud_firestore.dart';
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
    //UserCredential userCredential =
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      User user = userCredential.user;

      DocumentSnapshot documentSnapshot =
          await DatabaseMethods().getUserUsername(user.uid);
      SharedPreferenceHelper()
          .saveUserName(documentSnapshot.data()["username"]);
      SharedPreferenceHelper().saveUserEmail(user.email);
      SharedPreferenceHelper().saveIsLoggedIn(true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      print(error);
    });
  }

  // sign up function & save data to shared preference
  Future<bool> signUpWithEmailAndPassword(String username, String email,
      String password, BuildContext context) async {
    bool isSuccess = false;
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      isSuccess = true;

      User user = userCredential.user;

      SharedPreferenceHelper().saveUserName(username);
      SharedPreferenceHelper().saveUserEmail(user.email);
      SharedPreferenceHelper().saveIsLoggedIn(true);

      DatabaseMethods().uploadUserInfo(user.email, username).then((value) => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()))
          });
    }).catchError((error) {
      print(error);
    });

    return isSuccess;
  }

  // sign out

  signOut(BuildContext context) {
    _auth.signOut();
    SharedPreferenceHelper().saveIsLoggedIn(false);
    SharedPreferenceHelper().saveUserEmail("");
    SharedPreferenceHelper().saveUserName("");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }
}
