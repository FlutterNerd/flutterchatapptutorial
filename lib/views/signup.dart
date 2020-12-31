import 'package:flutter/material.dart';
import 'package:flutterchatapptutorial/services/auth.dart';
import 'package:flutterchatapptutorial/views/signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameTextEdittingController =
      TextEditingController();
  TextEditingController emailTextEdittingController = TextEditingController();
  TextEditingController passwordTextEdittingController =
      TextEditingController();

  bool isLoding = false;

  onSignUpBtnClick(BuildContext context) {
    setState(() {
      isLoding = true;
    });

    AuthMethods()
        .signUpWithEmailAndPassword(
            usernameTextEdittingController.text,
            emailTextEdittingController.text,
            passwordTextEdittingController.text,
            context)
        .then((isSuccess) {
      if (!isSuccess) {
        setState(() {
          isLoding = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChatApp"),
      ),
      body: isLoding
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      controller: usernameTextEdittingController,
                      decoration: InputDecoration(hintText: "username"),
                    ),
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
                    InkWell(
                      onTap: () {
                        onSignUpBtnClick(context);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24)),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign Up",
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
                            "Already have account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Text(
                              "Signin Now",
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
