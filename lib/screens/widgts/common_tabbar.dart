// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/users_screen.dart';

import 'package:one_to_one_chat_with_firestore/utils.dart';

class CommonTabBar extends StatelessWidget {
  int pageIndex;
  CommonTabBar({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MaterialButton(
          minWidth: width * 0.28,
          splashColor: AppColors.darkPurple,
          elevation: 0,
          shape: StadiumBorder(),
          onPressed: pageIndex == 1
              ? () {}
              : () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                },
          color: pageIndex == 1
              ? AppColors.darkPurple.withOpacity(1)
              : AppColors.darkPurple.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.012),
            child: Text(
              'Chats',
              style: TextStyle(
                  fontSize: Utils.verticalHorizonalRatioSize(
                      context: context, size: 6),
                  letterSpacing: width * 0.003,
                  color: pageIndex == 1
                      ? AppColors.white
                      : AppColors.strongDarkPurple),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        MaterialButton(
          minWidth: width * 0.28,
          splashColor: AppColors.darkPurple,
          elevation: 0,
          shape: StadiumBorder(),
          onPressed: pageIndex == 2
              ? () {}
              : () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => UsersScreen(),
                  //     ));
                },
          color: pageIndex == 2
              ? AppColors.darkPurple.withOpacity(1)
              : AppColors.darkPurple.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.012),
            child: Text(
              'Status',
              style: TextStyle(
                  fontSize: Utils.verticalHorizonalRatioSize(
                      context: context, size: 6),
                  letterSpacing: width * 0.003,
                  color: pageIndex == 2
                      ? AppColors.white
                      : AppColors.strongDarkPurple),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        MaterialButton(
          minWidth: width * 0.28,
          splashColor: AppColors.darkPurple,
          elevation: 0,
          shape: StadiumBorder(),
          onPressed: pageIndex == 3
              ? () {}
              : () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsersScreen(),
                      ));
                },
          color: pageIndex == 3
              ? AppColors.darkPurple.withOpacity(1)
              : AppColors.darkPurple.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.012),
            child: Text(
              'Contacts',
              style: TextStyle(
                  fontSize: Utils.verticalHorizonalRatioSize(
                      context: context, size: 6),
                  letterSpacing: width * 0.003,
                  color: pageIndex == 3
                      ? AppColors.white
                      : AppColors.strongDarkPurple),
            ),
          ),
        )
      ],
    );
  }
}
