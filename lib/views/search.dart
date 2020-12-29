import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/services/database.dart';

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
                          SearchUserTile(querySnapshot.docs[index]["email"])
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
  final String email;
  SearchUserTile(this.email);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(email), Icon(Icons.message)],
      ),
    );
  }
}
