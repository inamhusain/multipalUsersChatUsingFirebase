// ignore_for_file:prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/auth/signin_screen.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool userVisited = false;
  var email = "";
  var homeScreen;
  @override
  void initState() {
    getuserVisited();
    super.initState();
  }

  getuserVisited() async {
    email = (await SharedPreferenceHalper().getUserEmail())!;
    if (await SharedPreferenceHalper().getUserIsVisited()) {
      userVisited = true;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    } else {
      userVisited = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPurple,
      body: SafeArea(
        child: WelcomeMessages(context),
      ),
    );
  }

  WelcomeMessages(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Container(
            height: height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/welcome_image.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Spacer(flex: 3),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: Text(
              "Welcome to our freedom messaging app",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.strongDarkPurple,
                fontSize:
                    Utils.verticalHorizonalRatioSize(context: context, size: 8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Text("freedom talk any person of your mother language.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: Utils.verticalHorizonalRatioSize(
                      context: context, size: 5),
                  letterSpacing: width * 0.002,
                )),
          ),
          Spacer(flex: 3),
          Container(
            padding: EdgeInsets.only(bottom: height * 0.01),
            child: MaterialButton(
              splashColor: AppColors.strongDarkPurple,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: Utils.verticalHorizonalRatioSize(
                            context: context, size: 6),
                        color: AppColors.strongDarkPurple,
                        letterSpacing: width * 0.002),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.strongDarkPurple,
                    size: Utils.verticalHorizonalRatioSize(
                      context: context,
                      size: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<bool> _exit() async {
  //   return await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //         content: Container(
  //           padding: EdgeInsets.all(0),
  //           height: 150.0,
  //           width: 200.0,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "Are you sure to exit from app?",
  //                 style: TextStyle(fontSize: 15),
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 3),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text("No"),
  //                   ),
  //                   SizedBox(width: 10),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       SystemNavigator.pop();
  //                     },
  //                     child: Text(
  //                       "Yes",
  //                       style: TextStyle(fontSize: 12),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
