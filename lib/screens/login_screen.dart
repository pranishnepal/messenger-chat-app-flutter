import 'package:flutter/material.dart';
import 'package:group_chat_app/components/login_form.dart';

class LoginScreen extends StatefulWidget {
  static String routeKey = "signin";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              SignInForm(),
            ],
          ),
        ));
  }
}
