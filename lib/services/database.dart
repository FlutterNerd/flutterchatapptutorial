import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchatapptutorial/helping_functions/shared_pre_helper.dart';

class DatabaseMethods {
  Future uploadUserInfo(String email, String username) {
    return FirebaseFirestore.instance
        .collection("users")
        .add({"email": email, "username": username}).catchError((error) {
      print(error);
    });
  }

  Future<QuerySnapshot> searchUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<DocumentSnapshot> getUserUsername(String uid) {
    print("GETTING USERID FOR UID ${uid}");
    return FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  Future checkIfChatRoomExists(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
  }

  Future createChatRoom(String chatRoomId, Map chatRoomData) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(chatRoomData)
        .catchError((eroor) {
      print(eroor);
    });
  }

  Future addAMessage(String chatRoomId, Map messageData) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageData)
        .catchError((eroor) {
      print(eroor);
    });
  }

  createChatroom(String usernameSearching) async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    // create chatroomm
    FirebaseFirestore.instance.collection("chatrooms").add({
      "last_message_send": "hey",
      "last_message_ts": DateTime.now(),
      "user": [usernameSearching, myUsername]
    });
  }

  Future<Stream> getChatMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream> getMyChats() async {
    String myName = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: myName)
        .snapshots();
  }

  updateLastMessage(String chatRoomId, Map updatedData) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(updatedData);
  }
}
