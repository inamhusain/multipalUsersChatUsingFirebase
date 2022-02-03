// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_halper.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  String userID;
  ChatScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final FirebaseHalper _service = FirebaseHalper();
  TextEditingController _messageController = TextEditingController();
  List chatListData = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(userID == Utils.user1ID ? "user 1" : "user 2"),
      ),
      body: Container(
        height: height,
        margin: EdgeInsets.symmetric(
                horizontal: width * 0.030, vertical: height * 0.01)
            .copyWith(bottom: 0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _service.chatStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('somthing went wrong'),
                        );
                      } else if (snapshot.data == null ||
                          snapshot.data!.size == 0) {
                        return Center(
                          child: Text('No Chat Found'),
                        );
                      }
                      chatListData = _service.snapToList(snapshot: snapshot);
                      return chatList(chatListData, width, height);
                    },
                  ),
                  // Spacer(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: sendMessageBar(context: context, chatListData: chatListD),
            )
          ],
        ),
      ),
    );
  }

  Widget chatList(List<dynamic> _chatList, double width, double height) {
    return Container(
      height: height * 0.8,
      child: ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          return Align(
            alignment: _chatList[index]['sender'] == userID
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.02),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _chatList[index]['message'],
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }

  sendMessageBar({context, chatListData}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.004),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.65,
            child: Utils.commonTextField(
                context: context, controller: _messageController),
          ),
          IconButton(
            onPressed: () {
              FirebaseHalper()
                  .sendChat(message: _messageController.text, sender: userID);
            },
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
