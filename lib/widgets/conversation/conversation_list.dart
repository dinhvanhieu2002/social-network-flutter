import 'package:flutter/material.dart';
import 'conversation_item.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({super.key});

  //conversation list data

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Replace with the actual number of conversations
      itemBuilder: (context, index) {
        return ConversationItem(
          avatarUrl: 'urrl',
          username: 'John Doe',
          lastMessage: 'Hello there!',
          lastMessageAt: DateTime.now(),
          onTap: () {
            // Handle opening the conversation here
          },
        );
      },
    );
  }
}
