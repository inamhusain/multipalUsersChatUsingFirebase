// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class Utils {
  static String user1ID = "USER1";
  static String user2ID = "USER2";
  static verticalHorizonalRatioSize({context, size}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return (height / 10 * width / 10) / 1000 * size;
  }

  static SnapToList({snapshot}) {
    final _list = [];

    snapshot.data!.docs.map((doc) {
      Map _chat = doc.data();
      _list.add(_chat);
    }).toList();
    return _list;
  }

  static commonTextField({context, controller}) {
    return TextField(
      controller: controller,
      style: TextStyle(
          letterSpacing: 1.2,
          color: AppColors.strongDarkPurple,
          fontSize: verticalHorizonalRatioSize(context: context, size: 6)),
      cursorColor: AppColors.strongDarkPurple,
      decoration: InputDecoration(
        hintText: "send message",
        hintStyle: TextStyle(
            color: AppColors.strongDarkPurple,
            fontSize:
                Utils.verticalHorizonalRatioSize(context: context, size: 6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: AppColors.strongDarkPurple,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: AppColors.strongDarkPurple,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

class FirebaseCollectionName {
  static String messagesCollection = 'massages';
  static String usersCollection = 'users';
  static String chatRoomCollection = 'chatroom';
}

class SharedPreferenceKeys {
  static String userVisitedkey = 'userVisited';
  static String userEmailKey = 'useremail';
}

class AppColors {
  static Color purple = Color(0xff7C80EE);
  static Color lightPurple = Color(0XFFede8f9);
  static Color darkPurple = Color(0xff696a92);
  static Color strongDarkPurple = Color(0xff20124d);
  static Color black = Colors.black;
  static Color white = Colors.white;
}
