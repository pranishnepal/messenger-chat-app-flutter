import 'package:flutter/material.dart';
import 'package:group_chat_app/components/signup_form.dart';

class RegisterScreen extends StatefulWidget {
  static String routeKey = "signup";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff262C31),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /* icon */
              Hero(
                tag: "appLogo",
                child: Icon(
                  Icons.forum,
                  color: Colors.pink,
                  size: 100.0,
                ),
              ),
              SignUpForm(),
            ],
          ),
        ));
  }
}
