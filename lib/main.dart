import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:myschooly/src/providers/school_code_provider.dart';
import 'package:myschooly/src/providers/auth_provider.dart';
import 'package:myschooly/src/providers/network_provider.dart';
import 'package:myschooly/src/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SchoolCodeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuth()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: const SchoolyApp(),
    );
  }
}

class SchoolyApp extends StatefulWidget {
  const SchoolyApp({super.key});

  @override
  State<SchoolyApp> createState() => _SchoolyAppState();
}

class _SchoolyAppState extends State<SchoolyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final net = context.read<NetworkProvider>();
    final auth = context.read<AuthProvider>();
    _router = AppRouter.build(net, auth);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MySchooly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
