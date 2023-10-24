import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/login.dart';
import 'package:social_network/screens/auth_ui/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomTabScreen(),
    );
  }
}

