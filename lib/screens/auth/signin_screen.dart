// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields, must_be_immutable, deprecated_member_use, prefer_const_constructors_in_immutables, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/screens/auth/signup_screen.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_auth_handler.dart';
import 'package:one_to_one_chat_with_firestore/halpers/auth_exception_handler.dart';
import 'package:one_to_one_chat_with_firestore/screens/home_screen.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuthHandler _authService = FirebaseAuthHandler();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.lightPurple,
      key: _scaffoldKey,
      body: Center(
          child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.5,
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
                      'Sign In',
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
                        controller: _emailController,
                        context: context,
                        label: 'email',
                        width: width),
                    SizedBox(height: height * 0.015),

                    commonTextField(
                        controller: _passwordController,
                        context: context,
                        label: 'password',
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
                          dynamic _result =
                              await _authService.signInWithEmailPass(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          print('Status  $_result');
                          if (_result == AuthResultStatus.successful) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                            print('signed in');
                          } else {
                            _scaffoldKey.currentState?.showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: AppColors.strongDarkPurple,
                                content: Text(
                                  "${AuthExceptionHandler.exceptionMessage(authStatus: _result)}",
                                  style: TextStyle(
                                      fontSize:
                                          Utils.verticalHorizonalRatioSize(
                                              context: context, size: 5)),
                                ),
                              ),
                            );
                          }
                        } else {
                          _scaffoldKey.currentState?.showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColors.strongDarkPurple,
                              content: Text(
                                'Please Enter value'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: Utils.verticalHorizonalRatioSize(
                                        context: context, size: 5)),
                              )));
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: AppColors.lightPurple,
                            fontSize: Utils.verticalHorizonalRatioSize(
                                context: context, size: 5),
                            letterSpacing: width * 0.002),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Visibility(
                    //   visible: true,
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       var res = await _authService.googleSignIn(context);
                    //       if (res == AuthResultStatus.successful) {
                    //         Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => HomeScreen(),
                    //             ));
                    //       } else {
                    //         print(
                    //             AuthExceptionHandler.exceptionMessage(authStatus: res));
                    //       }
                    //     },
                    //     child: Text('Sign In with google'),
                    //   ),
                    // ),
                    MaterialButton(
                      shape: StadiumBorder(),
                      color: AppColors.strongDarkPurple,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: AppColors.lightPurple),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
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
