import 'package:flutter/material.dart';
import 'package:group_chat_app/screens/chat_screen.dart';
import 'package:group_chat_app/screens/home_screen.dart';
import 'package:group_chat_app/screens/login_screen.dart';
import 'package:group_chat_app/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Chat',
      theme: ThemeData.dark(),
      initialRoute: HomeScreen.routeKey,
      routes: {
        ChatScreen.routeKey: (context) {
          return ChatScreen();
        },
        HomeScreen.routeKey: (context) {
          return HomeScreen();
        },
        LoginScreen.routeKey: (context) {
          return LoginScreen();
        },
        RegisterScreen.routeKey: (context) {
          return RegisterScreen();
        },
      },
    );
  }
}
