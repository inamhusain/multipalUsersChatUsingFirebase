// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields, must_be_immutable, unnecessary_null_comparison, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/auth_exception_handler.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/auth/signin_screen.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_auth_handler.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthHandler _authService = FirebaseAuthHandler();
  bool isloading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightPurple,
        key: _scaffoldKey,
        body: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/welcome_image.png'),
                        fit: BoxFit.fitWidth),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.02),
                  child: Column(
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(
                            color: AppColors.strongDarkPurple,
                            fontSize: Utils.verticalHorizonalRatioSize(
                              context: context,
                              size: 7,
                            ),
                            fontWeight: FontWeight.bold,
                            letterSpacing: width * 0.002),
                      ),
                      SizedBox(height: height * 0.015),
                      commonTextField(
                          context: context,
                          controller: _nameController,
                          label: 'Username',
                          width: width),
                      SizedBox(height: height * 0.015),
                      commonTextField(
                          context: context,
                          controller: _emailController,
                          label: 'Email',
                          width: width),
                      SizedBox(height: height * 0.015),
                      commonTextField(
                          context: context,
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                          width: width),
                      SizedBox(height: height * 0.02),
                      MaterialButton(
                        minWidth: width * 0.5,
                        height: height * 0.05,
                        shape: StadiumBorder(),
                        color: AppColors.strongDarkPurple,
                        onPressed: () async {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            dynamic result = await _authService.createNewUser(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _nameController.text);
                            if (result == AuthResultStatus.successful) {
                              await SharedPreferenceHalper().setUserIsVisited();
                              await SharedPreferenceHalper()
                                  .setUserEmail(email: _emailController.text);

                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ));
                              _emailController.clear();
                              _passwordController.clear();
                              _nameController.clear();
                            }
                          } else {
                            _scaffoldKey.currentState?.showSnackBar(SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('Please Enter value')));
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: AppColors.lightPurple,
                              fontSize: Utils.verticalHorizonalRatioSize(
                                  context: context, size: 5),
                              letterSpacing: width * 0.002),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      MaterialButton(
                        shape: StadiumBorder(),
                        color: AppColors.strongDarkPurple,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                        },
                        child: Text(
                          'Sign In ',
                          style: TextStyle(color: AppColors.lightPurple),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  commonTextField({controller, obscureText, context, label, width}) {
    return TextField(
      style: TextStyle(
          fontSize: Utils.verticalHorizonalRatioSize(context: context, size: 6),
          letterSpacing: width * 0.009,
          fontWeight: FontWeight.bold,
          color: AppColors.strongDarkPurple),
      cursorColor: AppColors.strongDarkPurple,
      obscureText: obscureText ?? false,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: TextStyle(color: AppColors.strongDarkPurple),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              Utils.verticalHorizonalRatioSize(context: context, size: 50)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              Utils.verticalHorizonalRatioSize(context: context, size: 50)),
          borderSide: BorderSide(
            color: AppColors.strongDarkPurple,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
