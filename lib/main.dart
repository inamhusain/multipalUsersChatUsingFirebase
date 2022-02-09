// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_chat_halper.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/auth/signin_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/splash_screen.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

void main() async {
  await FirebaseChatHalper.firebaseInit();
  // await SharedPreferenceHalper().getInitValues();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userVisited = false;
  var email = "";
  var homeScreen;

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
