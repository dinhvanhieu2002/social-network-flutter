import 'package:social_network/screens/auth_ui/login_screen.dart';
import 'package:social_network/screens/auth_ui/signup_screen.dart';
import 'package:social_network/screens/chat_screen.dart';
import 'package:social_network/screens/conversations_screen.dart';
import 'package:social_network/screens/bottom_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/screens/create_post_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
  '/signup': (route) => const MaterialPage(child: SignUpScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: BottomTabScreen()),
  //search, profile, image picker, notify
  // '/conversations': (route) => MaterialPage(
  //       child: ConversationsScreen(),
  //     ),
  // '/conversation/:id': (route) => MaterialPage(
  //       child: ChatScreen(
  //         id: route.pathParameters['id'] ?? '',
  //       ),
  //     ),

  '/conversations': (route) => const MaterialPage(child: ConversationsScreen()),
  '/conversations/:conversationId': (route) => MaterialPage(child: ChatScreen(conversationId: route.pathParameters['conversationId'] ?? '')),
  '/create-post': (route) => const MaterialPage(child: CreatePostScreen()),
});
