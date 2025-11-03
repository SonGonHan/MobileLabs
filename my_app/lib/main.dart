import 'package:flutter/material.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/book_detail_screen.dart';
import 'package:my_app/screens/cart_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookStore',
      home: RegistrationScreen(),
    );

  }
}