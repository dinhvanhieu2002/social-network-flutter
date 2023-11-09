import 'package:flutter/material.dart';
import 'package:social_network/widgets/conversation/conversation_list.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
      ),
      body: const ConversationList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle composing a new message here
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
