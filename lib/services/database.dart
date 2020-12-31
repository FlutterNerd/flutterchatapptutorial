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
    return FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  checkIfChatRoomExists(String usernameSearching) async {
    String myUsername = await SharedPreferenceHelper().getUserName();

    if (myUsername != usernameSearching) {
      FirebaseFirestore.instance
          .collection("chatrooms")
          .where("users", arrayContains: [usernameSearching, myUsername])
          .get()
          .then((querySnapshot) {
            try {
              if (querySnapshot.docs.isEmpty) {
                print("chat room already exixts");
              } else {
                print(
                    "chat room does not  exixts for $usernameSearching $myUsername");
                //createChatroom(usernameSearching);
              }
            } catch (error) {
              print("chat room does not  exixts $error");
            }
          });
    }
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
}
