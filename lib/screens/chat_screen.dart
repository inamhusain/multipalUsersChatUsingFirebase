// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, avoid_print, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:one_to_one_chat_with_firestore/halpers/firebase_chat_halper.dart';
import 'package:one_to_one_chat_with_firestore/halpers/image_hapler.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class ChatScreen extends StatelessWidget {
  String currentUserEmail;
  String reciverEmail;
  String reciverName;
  String username;

  ChatScreen({
    Key? key,
    required this.currentUserEmail,
    required this.reciverEmail,
    required this.reciverName,
    required this.username,
  }) : super(key: key);

  final FirebaseChatHalper _service = FirebaseChatHalper();
  final TextEditingController _messageController = TextEditingController();
  var id = 0;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightPurple,
        appBar: AppBar(
          backgroundColor: AppColors.strongDarkPurple,
          title: Text(
            reciverName,
            style: TextStyle(
                fontSize: Utils.verticalHorizonalRatioSize(
                    context: context, size: 7)),
          ),
          toolbarHeight: height * 0.07,
        ),
        body: Container(
          height: height,
          child: Column(
            children: [
              SizedBox(height: height * 0.005),
              StreamBuilder<QuerySnapshot>(
                stream: _service.chatStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('somthing went wrong'),
                    );
                  } else if (snapshot.data == null ||
                      snapshot.data!.size == 0) {
                    return Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            'No Chat Found',
                            style: TextStyle(
                                fontSize: Utils.verticalHorizonalRatioSize(
                                    context: context, size: 6)),
                          ),
                        ),
                      ),
                    );
                  }
                  return chatList(
                      width: width, height: height, snapshot: snapshot);
                },
              ),
              sendMessageBar(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatList({snapshot, width, height}) {
    List chatListData = Utils.SnapToList(snapshot: snapshot);
    id = int.parse(chatListData.last['id']);
    if (_controller.hasClients) {
      print("Max scroll event ${_controller.position.maxScrollExtent}");
      _controller.animateTo(
        _controller.position.maxScrollExtent + 200,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          shrinkWrap: true,
          itemCount: chatListData.length,
          itemBuilder: (context, index) {
            if (chatListData[index]['reciver'] != reciverEmail &&
                    chatListData[index]['sender'] != reciverEmail ||
                chatListData[index]['reciver'] != currentUserEmail &&
                    chatListData[index]['sender'] != currentUserEmail) {
              return Container();
            }
            if (chatListData[index]['reciver'] == currentUserEmail) {
              //todo: update message where reciver = current user.
              // FirebaseChatHalper()
              //     .updateReadStatusOfMessages(reciverEmail: currentUserEmail);
            }
            return Align(
              alignment: chatListData[index]['sender'] == currentUserEmail
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: chatListData[index]['messageType'] == 'TEXT'
                  ? Container(
                      constraints: BoxConstraints(maxWidth: width * 0.5),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.07, vertical: height * 0.02),
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.005),
                      decoration: BoxDecoration(
                        color: AppColors.strongDarkPurple,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.zero,
                            bottomLeft: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Text(
                        chatListData[index]['message'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: AppColors.lightPurple,
                            fontSize: Utils.verticalHorizonalRatioSize(
                                context: context, size: 5),
                            letterSpacing: width * 0.002),
                      ))
                  : Container(
                      width: width * 0.55,
                      height: height * 0.25,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.zero,
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        // border: Border.all(),
                      ),
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.005),
                      child: CachedNetworkImage(
                        imageUrl: chatListData[index]['message'],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return SizedBox(
                              height: height * 0.05,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.strongDarkPurple,
                              )));
                        },
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  sendMessageBar({context}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.lightPurple,
      width: width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.007),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: width * 0.65,
            child: Utils.commonTextField(
                context: context, controller: _messageController),
          ),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, value, child) {
              return value == true
                  ? SizedBox(
                      height: height * 0.02,
                      width: height * 0.02,
                      child: CircularProgressIndicator(
                        color: AppColors.strongDarkPurple,
                        strokeWidth: 2,
                      ))
                  : IconButton(
                      onPressed: () {
                        FirebaseChatHalper().sendChat(
                            index: id,
                            message: _messageController.text,
                            sender: currentUserEmail,
                            reciver: reciverEmail,
                            messageType: MessageType.TEXT,
                            userName: username);
                        _messageController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: AppColors.strongDarkPurple,
                      ),
                    );
            },
          ),
          IconButton(
            onPressed: () {
              ImageHalper().sendImage(
                  isLoading: isLoading,
                  id: id,
                  sender: currentUserEmail,
                  reciver: reciverEmail,
                  username: username);
            },
            icon: Icon(Icons.image, color: AppColors.strongDarkPurple),
          )
        ],
      ),
    );
  }
}
