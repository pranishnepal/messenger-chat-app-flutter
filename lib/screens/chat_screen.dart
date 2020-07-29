import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:group_chat_app/constants.dart';
import 'package:group_chat_app/messages/chat_bubble.dart';
import 'package:group_chat_app/screens/home_screen.dart';

FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static String routeKey = "chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fstore = Firestore.instance;
  final controller = new TextEditingController();

  String message;

  void getCurrUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.displayName);
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*-----------------------------App Bar Starts-------------------------- */
      appBar: AppBar(
        backgroundColor: Color(0xffFF434E),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            /* go back */
            Navigator.popAndPushNamed(context, HomeScreen.routeKey);
          },
        ),
        title: Text(
          "Group Chat",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          DropdownButton(
            dropdownColor: Color(0xffFF434E),
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                value: 'Logout',
              ),
            ],
            onChanged: (menuItem) {
              if (menuItem == "Logout") {
                /* signout */
                _auth.signOut();
                Navigator.popAndPushNamed(context, HomeScreen.routeKey);
              }
            },
          ),
        ],
      ),
      backgroundColor: Color(0xff262C31),
      /*-----------------------------App Bar Ends-----------------------------*/
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessageStream(),
            ),
            Container(
              decoration: kMessageDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        /* when user types */
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      /* when user hits send, adds texts */
                      _fstore.collection('messages').add({
                        'senderName': loggedInUser.displayName,
                        'text': message,
                        'time': DateTime.now(),
                        'senderEmail': loggedInUser.email,
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Color(0xffFF434E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final _fstore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _fstore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messageStream = snapshot.data.documents;
        return ListView.builder(
          itemCount: messageStream.length,
          itemBuilder: (context, itemIndex) {
            return ChatBubble(
              isMe: (messageStream[itemIndex]['senderEmail'] ==
                  loggedInUser.email),
              senderName: messageStream[itemIndex]['senderName'],
              text: messageStream[itemIndex]['text'],
            );
          },
        );
      },
    );
  }
}
