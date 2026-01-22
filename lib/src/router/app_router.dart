import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myschooly/signin/schoolcodescreen.dart';
import 'package:myschooly/signin/loginscreen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const SchoolCodeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),
  ],
);
