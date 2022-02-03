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
      FirebaseFirestore.instance.collection('chat').orderBy(field).snapshots();
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chat');

  snapToList({snapshot}) {
    final _chatList = [];
    snapshot.data!.docs.map((doc) {
      Map _chat = doc.data();
      _chatList.add(_chat);
    }).toList();
    return _chatList;
  }

  Future sendChat({int? lastIndex, String? message, String? sender}) {
    int id = lastIndex! + 1;
    return _chatCollection
        .add({'id': id, 'message': message, 'sender': sender})
        .then((value) => print('message send'))
        .onError((error, stackTrace) {
          print(error);
        });
  }
}
