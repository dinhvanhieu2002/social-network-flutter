import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String lastMessage;
  final DateTime lastMessageAt;
  final VoidCallback onTap;

  const ConversationItem(
      {super.key,
      required this.avatarUrl,
      required this.username,
      required this.lastMessage,
      required this.lastMessageAt,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle:
            Row(children: [Text(lastMessage), Text(lastMessageAt.toString())]),
      ),
    );
  }
}
