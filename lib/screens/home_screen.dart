// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_string_interpolations, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_auth_handler.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_chat_halper.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_user_halper.dart';

import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/auth/signin_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/chat_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/users_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/widgts/common_tabbar.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentUsername = '';
  String currentUid = '';
  String currentUserEmail = '';
  int appBarIndex = 1;
  @override
  void initState() {
    getUserdetails();
    super.initState();
  }

  getUserdetails() async {
    currentUserEmail = (await SharedPreferenceHalper().getUserEmail())!;
    QuerySnapshot<Map<String, dynamic>> _userDetail = await FirebaseUserHalper()
        .getCurrentUserDetails(email: currentUserEmail);
    // print(_userDetail.docs[0]['username']);
    currentUsername = await _userDetail.docs[0]['username'];
    currentUid = await _userDetail.docs[0]['uid'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightPurple,
      appBar: AppBar(
        backgroundColor: AppColors.strongDarkPurple,
        title: Text('$currentUsername'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                FirebaseAuthHandler().signOut();
                await SharedPreferenceHalper().clearUserIsVisited();
                await SharedPreferenceHalper().clearUserEmail();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTabBar(
              pageIndex: 1,
            ),
            SizedBox(height: height * 0.02),
            chatList(width: width, height: height),
          ],
        ),
      ),
    );
  }

  chatList({width, height}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseChatHalper.chatroomCollectionStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        List chatrooms = Utils.SnapToList(snapshot: snapshot);

        return Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(overscroll: false),
            child: ListView.builder(
              itemCount: chatrooms.length,
              itemBuilder: (context, index) {
                if (chatrooms[index]['creatdeby'] == currentUserEmail) {
                  return chatrooms[index]['creatdeby'] == currentUserEmail
                      ? userCard(
                          email: chatrooms[index]['createdfor'],
                          width: width,
                          height: height)
                      : userCard(
                          email: chatrooms[index]['creatdeby'],
                          width: width,
                          height: height);
                } else if (chatrooms[index]['createdfor'] == currentUserEmail) {
                  return chatrooms[index]['createdfor'] == currentUserEmail
                      ? userCard(
                          email: chatrooms[index]['creatdeby'],
                          width: width,
                          height: height)
                      : userCard(
                          email: chatrooms[index]['createdfor'],
                          width: width,
                          height: height);
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }

  userCard({email, width, height}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollectionName.usersCollection)
          .where('email', isEqualTo: email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        List usersList = Utils.SnapToList(snapshot: snapshot);
        print(usersList);
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    reciverName: usersList[0]['username'],
                    currentUserEmail: currentUserEmail,
                    reciverEmail: usersList[0]['email'],
                    username: currentUsername,
                  ),
                ));
          },
          child: Card(
            color: AppColors.strongDarkPurple,
            shape: StadiumBorder(),
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.01),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.lightPurple,
                  radius: Utils.verticalHorizonalRatioSize(
                      context: context, size: 8),
                  child: Text(
                    "${usersList[0]['username']}".substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: AppColors.strongDarkPurple,
                        fontSize: Utils.verticalHorizonalRatioSize(
                            context: context, size: 7),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  usersList[0]['username'],
                  style: TextStyle(
                    color: AppColors.lightPurple,
                    fontSize: Utils.verticalHorizonalRatioSize(
                        context: context, size: 7),
                    letterSpacing: width * 0.002,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
