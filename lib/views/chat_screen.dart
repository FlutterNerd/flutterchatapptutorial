import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';
import 'package:flutterchatapptutorial/services/database.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen(this.chatRoomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String myName = "";

  Stream chatMessagedStream;

  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  getChats() async {
    chatMessagedStream =
        await DatabaseMethods().getChatMessages(widget.chatRoomId);
  }

  Widget messageList() {
    return StreamBuilder(
      stream: chatMessagedStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 12, bottom: 70),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  return messageTile(ds["message"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget messageTile(String message) {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Color(0xfff1f0f0),
            child: Text(message)),
      ],
    );
  }

  sendAMessage() async {
    var ts = DateTime.now();
    Map<String, dynamic> messageData = {
      "message": messageTextEditingController.text,
      "sendBy": myName,
      "time": ts
    };

    await DatabaseMethods().addAMessage(widget.chatRoomId, messageData);

    Map<String, dynamic> updatedData = {
      "last_message": messageTextEditingController.text,
      "sendBy": myName,
      "last_message_ts": ts
    };

    await DatabaseMethods().updateLastMessage(widget.chatRoomId, updatedData);
  }

  @override
  void initState() {
    getMyInfoFromSharedPreference();
    getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.chatRoomId.replaceAll(myName, "").replaceAll("_", "")),
      ),
      body: Container(
        child: Stack(
          children: [
            messageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.blue.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Enter a message",
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          if (messageTextEditingController.text != "") {
                            sendAMessage();
                            messageTextEditingController.text = "";
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.all(6),
                            color: Colors.blue,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
