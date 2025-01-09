import 'package:chat_app/hivepostapp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Post App',
      home : const HivePostsApp(),
      debugShowCheckedModeBanner: false,
    );
  }

}

