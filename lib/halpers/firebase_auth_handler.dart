// ignore_for_file: empty_catches,unused_field, unused_local_variable, avoid_print, non_constant_identifier_names, unused_element, unnecessary_null_comparison, constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_to_one_chat_with_firestore/halpers/auth_exception_handler.dart';
import 'package:one_to_one_chat_with_firestore/halpers/shared_preference_halper.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

enum AuthResultStatus {
  successful,
  EMAIL_VERIFIED,
  EMAIL_LINK_EXPIRE,
  wrongPassword,
  invalidEmail,
  userNotFound,
  unknownError,
  weakpassword,
  emailAlredyInUse
}

class FirebaseAuthHandler {
  //* init Google sign In..

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  //
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus? _status;
  User? _user;
  User? get getUser => _user;
  AuthResultStatus? _emailVerified;
  AuthResultStatus? get getEmailVerified => _emailVerified;

  //* reg with email password
  Future createNewUser(
      {required String email,
      required String password,
      String? username}) async {
    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: email.toLowerCase(), password: password);
      _user = _result.user;
      if (_user != null) {
        await saveUserDetailsInFirestore(
            uid: _user!.uid, userName: username, email: email);
        _status = AuthResultStatus.successful;

        // verifyEmail();
      }
    } catch (e) {
      print(e);
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //* sign in email password
  Future signInWithEmailPass({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      _user = _result.user;
      if (_user != null) {
        _status = AuthResultStatus.successful;
        await SharedPreferenceHalper().setUserIsVisited();
        await SharedPreferenceHalper().setUserEmail(email: email);
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }

    return _status;
  }

  //* sign out
  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  //* Goole SignIn
  Future googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
      if (_googleSignInAccount != null) {
        GoogleSignInAuthentication _authentication =
            await _googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: _authentication.idToken,
            accessToken: _authentication.accessToken);
        try {
          UserCredential _userCredential =
              await _auth.signInWithCredential(authCredential);
          if (_userCredential != null) {
            await SharedPreferenceHalper().setUserIsVisited();
            await SharedPreferenceHalper()
                .setUserEmail(email: _userCredential.user!.email!);
            await saveUserDetailsInFirestore(
                uid: _userCredential.user!.uid,
                userName: _userCredential.user!.displayName,
                email: _userCredential.user!.email);
            _status = AuthResultStatus.successful;
            _user = _userCredential.user;
          }
        } on FirebaseAuthException catch (e) {
          _status = AuthExceptionHandler.handleException(e);
        }
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //* Google signOut
  googleSignOut() async {
    _googleSignIn.signOut();
  }

  // verifyEmail() async {
  //   var _counter = 0;
  //   _emailVerified = null;
  //   if (!_auth.currentUser!.emailVerified) {
  //     await _user!.sendEmailVerification();
  //     // it check after 30 sec if email is verify then sucess else link expire.
  //     var timer = Timer.periodic(Duration(seconds: 3), (timer) async {
  //       await _auth.currentUser!.reload();
  //       _counter++;
  //       print(_counter);

  //       if (_auth.currentUser!.emailVerified) {
  //         timer.cancel();
  //         _emailVerified = AuthResultStatus.EMAIL_VERIFIED;
  //         _user = _auth.currentUser;
  //       } else if (_counter == 5) {
  //         timer.cancel();
  //         _counter = 0;
  //         _emailVerified = AuthResultStatus.EMAIL_LINK_EXPIRE;
  //         _auth.currentUser!.delete();
  //       }
  //     });
  //   }
  // }

  saveUserDetailsInFirestore({uid, userName, email}) async {
    final CollectionReference _usersCollection = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.usersCollection);

    return _usersCollection
        .add({
          'uid': "$uid",
          'username': "$userName",
          'email': '$email',
        })
        .then((value) => print('user saved'))
        .onError((e, stackTrace) => print("firebase user store error :: $e"));
  }
}
