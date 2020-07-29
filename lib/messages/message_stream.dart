import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/messages/chat_bubble.dart';

class MessageStream extends StatefulWidget {
  final String currentUserEmail;
  MessageStream({this.currentUserEmail});

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  final _fstore = Firestore.instance;

  ScrollController _scrollController = new ScrollController();

  void scrollToEnd() {
    setState(() {
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    scrollToEnd();
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
          controller: _scrollController,
          itemCount: messageStream.length,
          itemBuilder: (context, itemIndex) {
            return ChatBubble(
              isMe: (messageStream[itemIndex]['senderName'] ==
                  widget.currentUserEmail),
              senderName: messageStream[itemIndex]['senderName'],
              text: messageStream[itemIndex]['text'],
            );
          },
        );
      },
    );
  }
}
