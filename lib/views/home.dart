import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/services/auth.dart';
import 'package:flutterchatapptutorial/views/search.dart';
import 'package:flutterchatapptutorial/views/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChatApp"),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}
