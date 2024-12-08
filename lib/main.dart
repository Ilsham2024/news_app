import 'package:flutter/material.dart';
import 'package:new_news_app/Screen/home_screen.dart';
//import 'package:new_news_app/Screen/login_screen.dart';
import 'package:new_news_app/Screen/signup_screen.dart';
import 'package:new_news_app/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const NewsHomeScreen(),
      },
    );
  }
}
