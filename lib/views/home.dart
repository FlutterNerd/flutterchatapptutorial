import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';
import 'package:flutterchatapptutorial/services/auth.dart';
import 'package:flutterchatapptutorial/services/database.dart';
import 'package:flutterchatapptutorial/views/chat_screen.dart';
import 'package:flutterchatapptutorial/views/search.dart';
import 'package:flutterchatapptutorial/views/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String myName;

  Stream chatsStream;

  getUserName() async {
    myName = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  getMyChats() async {
    chatsStream = await DatabaseMethods().getMyChats();
  }

  @override
  void initState() {
    getUserName();
    getMyChats();
    super.initState();
  }

  Widget chatsList() {
    return StreamBuilder(
        stream: chatsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];

                    return chatTile(ds.id, ds["last_message"]);
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget chatTile(String chatRoomId, String lastMessage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.blue.shade200,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatRoomId.replaceAll(myName, "").replaceAll("_", ""),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                lastMessage,
                style: TextStyle(fontSize: 14),
              )
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey $myName "),
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
      body: Container(
        child: chatsList(),
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
