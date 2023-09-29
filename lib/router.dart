import 'package:social_network/screens/auth_ui/login_screen.dart';
import 'package:social_network/screens/auth_ui/signup_screen.dart';
import 'package:social_network/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
  '/signup': (route) => const MaterialPage(child: SignUpScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  // '/document/:id': (route) => MaterialPage(
  //       child: DocumentScreen(
  //         id: route.pathParameters['id'] ?? '',
  //       ),
  //     ),
});
