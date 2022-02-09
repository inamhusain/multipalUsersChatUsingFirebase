// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_user_halper.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/chat_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/widgts/common_tabbar.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String currentUsername = '';
  String currentUid = '';
  String currentUserEmail = '';
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

    FirebaseUserHalper _userHalper = FirebaseUserHalper();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.strongDarkPurple,
          title: Text('$currentUsername'),
          centerTitle: true,
        ),
        backgroundColor: AppColors.lightPurple,
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          child: Column(
            children: [
              CommonTabBar(pageIndex: 3),
              StreamBuilder<QuerySnapshot>(
                stream: _userHalper.allUsersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Container(),
                    );
                  } else if (snapshot.data == null) {
                    return Text("No data found");
                  }
                  List usersList = Utils.SnapToList(snapshot: snapshot);

                  return Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (usersList[index]['email'] == currentUserEmail) {
                            return Container();
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      reciverName: usersList[index]['username'],
                                      currentUserEmail: currentUserEmail,
                                      reciverEmail: usersList[index]['email'],
                                      username: currentUsername,
                                    ),
                                  ));
                            },
                            child: Card(
                              color: AppColors.strongDarkPurple,
                              shape: StadiumBorder(),
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              elevation: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                    vertical: height * 0.013),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.lightPurple,
                                    radius: Utils.verticalHorizonalRatioSize(
                                        context: context, size: 8),
                                    child: Text(
                                      "${usersList[index]['username']}"
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: AppColors.strongDarkPurple,
                                          fontSize:
                                              Utils.verticalHorizonalRatioSize(
                                                  context: context, size: 7),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    usersList[index]['username'],
                                    style: TextStyle(
                                      color: AppColors.lightPurple,
                                      fontSize:
                                          Utils.verticalHorizonalRatioSize(
                                              context: context, size: 7),
                                      letterSpacing: width * 0.002,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
