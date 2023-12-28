import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/widgets/recent_chats.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 30.0,
          color: Colors.black,
          onPressed: () => Routemaster.of(context).replace('/'),
        ),
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: const RecentChats(),
    );
  }
}