import 'package:flutter/material.dart';
import 'package:reverse_engineering_bca/dashboard/dashboard.dart';

void main() {
  runApp(const MyBcaCloneApp());
}

class MyBcaCloneApp extends StatelessWidget {
  const MyBcaCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myBCA Clone',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF005BAC),
      ),
      home: const MyBcaHomeScreen(),
    );
  }
}
