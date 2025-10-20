import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busservice/provider/auth_provider.dart';

import 'module/screens/Home_Page.dart';
import 'module/screens/Login_Screen.dart';
import 'module/screens/Splash_Screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Service',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const SplashScreen(),
    );
  }
}
