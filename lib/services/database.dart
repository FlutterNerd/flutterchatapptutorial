import 'package:cloud_firestore/cloud_firestore.dart';

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
}
