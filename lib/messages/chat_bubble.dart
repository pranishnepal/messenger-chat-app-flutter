import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String senderName;
  final bool isMe;

  ChatBubble({this.isMe, this.senderName, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            senderName,
            style: TextStyle(
              color: Color(0xff808080),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Material(
            color: isMe ? Color(0xffFE394E) : Color(0xff424A50),
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 14.0,
              ),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}
