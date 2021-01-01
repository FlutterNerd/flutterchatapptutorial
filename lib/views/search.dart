import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';
import 'package:flutterchatapptutorial/services/database.dart';
import 'package:flutterchatapptutorial/views/chat_screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController userNameTextEdittingController =
      TextEditingController();

  QuerySnapshot querySnapshot;

  onSearchIconClick() async {
    querySnapshot = await DatabaseMethods()
        .searchUserByUsername(userNameTextEdittingController.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: TextField(
                controller: userNameTextEdittingController,
                decoration: InputDecoration(hintText: "username"),
              )),
              SizedBox(width: 16),
              GestureDetector(
                  onTap: () {
                    onSearchIconClick();
                  },
                  child: Icon(Icons.search))
            ]),
            querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SearchUserTile(querySnapshot.docs[index]["email"],
                              querySnapshot.docs[index]["username"])
                        ],
                      );
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class SearchUserTile extends StatelessWidget {
  final String email, username;
  SearchUserTile(this.email, this.username);

  Future<String> getChatRoomId(String searchUsername) async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    if (myUsername.substring(0).codeUnitAt(0) >
        searchUsername.substring(0).codeUnitAt(0)) {
      return "${searchUsername}_$myUsername";
    } else {
      return "${myUsername}_$searchUsername";
    }
  }

  Future createAChatRoom(String username, String chatRoomId) async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    List<String> users = [username, myUsername];

    Map<String, dynamic> chatRoomData = {"users": users};

    await DatabaseMethods().createChatRoom(chatRoomId, chatRoomData);
    sendAMessage(myUsername, chatRoomId);
  }

  sendAMessage(String myUsername, String chatRoomId) async {
    var ts = DateTime.now();
    Map<String, dynamic> messageData = {
      "message": "Hey",
      "sendBy": myUsername,
      "time": ts
    };

    await DatabaseMethods().addAMessage(chatRoomId, messageData);

    Map<String, dynamic> updatedData = {
      "last_message": "hey",
      "sendBy": myUsername,
      "last_message_ts": ts
    };

    await DatabaseMethods().updateLastMessage(chatRoomId, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(email),
          GestureDetector(
              onTap: () async {
                String chatRoomId = await getChatRoomId(username);
                DatabaseMethods()
                    .checkIfChatRoomExists(chatRoomId)
                    .then((value) async {
                  DocumentSnapshot documentSnapshot = value;
                  if (documentSnapshot.data() != null) {
                    print("chat room exists");
                    // send user to chat screen
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoomId)));
                  } else {
                    print("chat roo does not exists");

                    await createAChatRoom(username, chatRoomId);

                    // send user to chat screen
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoomId)));
                  }
                });
              },
              child: Icon(Icons.message))
        ],
      ),
    );
  }
}
