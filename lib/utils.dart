// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Utils {
  static String user1ID = "USER1";
  static String user2ID = "USER2";
  static fontSize({context, fontsize}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return (height / 10 * width / 10) / 1000 * fontsize;
  }

  static commonTextField({context, controller}) {
    return TextField(
      controller: controller,
      style: TextStyle(
          letterSpacing: 1.2,
          fontSize: fontSize(context: context, fontsize: 6)),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: "send message",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
