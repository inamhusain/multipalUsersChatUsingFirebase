// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';

void main() {
  FirebaseHalper.firebaseInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
