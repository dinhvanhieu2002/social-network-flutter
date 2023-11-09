import 'package:flutter/material.dart';

import "message_bubble.dart";

class Messages extends StatelessWidget {
  final chatDocs = [
    {
      "id": "abc",
      "text": "abc",
      "username": "hieudzai",
      "userImage": "zxczxc.png",
      "userId": "userid"
    },
    {
      "id": "abc",
      "text": "abc",
      "username": "hieudzai",
      "userImage": "zxczxc.png",
      "userId": "userid"
    },
    {
      "id": "abc",
      "text": "abc",
      "username": "hieudzai",
      "userImage": "zxczxc.png",
      "userId": "userid"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: chatDocs.length,
      itemBuilder: (ctx, index) => MessageBubble(
        chatDocs[index]['text']!,
        chatDocs[index]['username']!,
        chatDocs[index]['userImage']!,
        chatDocs[index]['userId']! as bool,
        key: ValueKey(chatDocs[index]["id"]),
      ),
    );
  }
}
