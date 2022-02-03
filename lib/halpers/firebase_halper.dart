// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHalper {
  static firebaseInit() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
  }

  final Stream<QuerySnapshot> chatStream =
      FirebaseFirestore.instance.collection('chat').snapshots();
}
