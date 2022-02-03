// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class ChatScreen extends StatelessWidget {
  String userID;
  ChatScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(userID == Utils.user1ID ? "user 1" : "user 2"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
                horizontal: width * 0.030, vertical: height * 0.01)
            .copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                width: width,
                height: height * 0.8,
              ),
              sendMessageBar(width: width, height: height),
            ],
          ),
        ),
      ),
    );
  }

  sendMessageBar({width, height}) {
    return Container(
      // color: Colors.amber,
      width: width,
      // height: 100,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.004),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.65,
            child: Utils.commonTextField(),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.send),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.image),
          )
        ],
      ),
    );
  }
}
