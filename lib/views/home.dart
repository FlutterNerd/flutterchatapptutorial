import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';
import 'package:flutterchatapptutorial/services/auth.dart';
import 'package:flutterchatapptutorial/views/search.dart';
import 'package:flutterchatapptutorial/views/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username;

  getUserName() async {
    username = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey $username "),
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
