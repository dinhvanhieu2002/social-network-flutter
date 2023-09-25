import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/select_option.dart'; // Import file select_option.dart

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
      home: const SelectOptionScreen(), // Sử dụng SelectOptionScreen làm màn hình chính
    );
  }
}

