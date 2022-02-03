// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/screens/chat_screen.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select User For Login'),
        centerTitle: true,
      ),
      body: Container(
        // color: Colors.black,
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.030, vertical: height * 0.01),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userID: Utils.user1ID),
                      ));
                },
                child: Text('Login As USER 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userID: Utils.user2ID),
                      ));
                },
                child: Text('Login As USER 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
