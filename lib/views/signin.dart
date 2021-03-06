import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/services/auth.dart';
import 'package:flutterchatapptutorial/views/home.dart';
import 'package:flutterchatapptutorial/views/signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPass = false;

  bool isLoading = false;

  TextEditingController emailTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController =
      TextEditingController();

  signInBtnClick() {
    if (emailTextEdittingController.text != "" &&
        passwordTextEdittingController.text != "") {
      setState(() {
        isLoading = true;
      });

      AuthMethods().signInWithEmailAndPassword(emailTextEdittingController.text,
          passwordTextEdittingController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChatApp"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      controller: emailTextEdittingController,
                      decoration: InputDecoration(hintText: "email"),
                    ),
                    TextField(
                      controller: passwordTextEdittingController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "password"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "forgot password",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        signInBtnClick();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24)),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Color(0xffffffff)),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              "Signup Now",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
