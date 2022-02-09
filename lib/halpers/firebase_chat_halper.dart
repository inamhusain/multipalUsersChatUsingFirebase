// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_is_empty, unused_local_variable, unnecessary_string_interpolations

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class FirebaseChatHalper {
  static firebaseInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.messagesCollection)
      .orderBy('id', descending: false)
      .snapshots();
  static Stream<QuerySnapshot> chatroomCollectionStream = FirebaseFirestore
      .instance
      .collection(FirebaseCollectionName.chatRoomCollection)
      .snapshots();
  final CollectionReference _chatCollection = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.messagesCollection);

  Future sendChat(
      {required int index,
      required String message,
      required String sender,
      required MessageType messageType,
      required String reciver,
      required String userName}) {
    String chatId = "$userName".toString() +
        "_${DateTime.now().millisecondsSinceEpoch}".toString();
    createChatRoom(currentEmail: sender, reciverEmail: reciver, chatID: chatId);

    int id = index + 1;
    return _chatCollection
        .add({
          'id': "$id",
          'message': message,
          'sender': sender,
          'reciver': reciver,
          'time': DateTime.now().millisecondsSinceEpoch,
          'messageType': messageType == MessageType.TEXT ? 'TEXT' : 'IMAGE',
          'chatRoomId': chatId,
          'messageRead': false,
        })
        .then((value) => print('message send'))
        .onError((error, stackTrace) {
          print("send chat error : $error");
        });
  }

  UploadTask? firebaseUplodeImage({destination, File? file}) {
    try {
      final _ref = FirebaseStorage.instance.ref(destination);
      return _ref.putFile(file!);
    } catch (e) {
      print('firebase image uplode error $e');
      return null;
    }
  }

  createChatRoom({currentEmail, reciverEmail, chatID}) {
    var chatRommAvaible = false;
    FirebaseFirestore.instance
        .collection(FirebaseCollectionName.chatRoomCollection)
        .get()
        .then((value) {
      if (value.docs.isEmpty || value.docs.length == 0) {
        FirebaseFirestore.instance
            .collection(FirebaseCollectionName.chatRoomCollection)
            .add({
              'roomid': chatID,
              'creatdeby': currentEmail,
              'createdfor': reciverEmail
            })
            .then((value) => print('chat room created'))
            .onError((error, stackTrace) {
              print("send chat error : $error");
            });
      } else {
        for (int index = 0; index < value.docs.length; index++) {
          if (value.docs[index]['creatdeby'] != currentEmail ||
              value.docs[index]['createdfor'] != reciverEmail) {
            if (value.docs[index]['createdfor'] != currentEmail ||
                value.docs[index]['creatdeby'] != reciverEmail) {
              chatRommAvaible = false;
            } else {
              chatRommAvaible = true;
              return 0;
            }
          } else {
            chatRommAvaible = true;
            return 0;
          }
        }
        if (chatRommAvaible == false) {
          FirebaseFirestore.instance
              .collection(FirebaseCollectionName.chatRoomCollection)
              .add({
                'roomid': chatID,
                'creatdeby': currentEmail,
                'createdfor': reciverEmail
              })
              .then((value) => print('chat room created'))
              .onError((error, stackTrace) {
                print("send chat error : $error");
              });
        }
      }
    });
  }

  deleteChatRoom({currentEmail, reciverEmail}) {
    FirebaseFirestore.instance
        .collection(FirebaseCollectionName.chatRoomCollection)
        .get()
        .then((value) {
      print(value);
    });
  }

  // updateUsers({senderEmail, reciveremnail, chatId}) async {
  //   QuerySnapshot<Map<String, dynamic>> _senderUserDetail =
  //       await FirebaseUserHalper().getCurrentUserDetails(email: senderEmail);
  //   var senderchatWithUsers = _senderUserDetail.docs[0]['chatwithusers'];
  //   List senderChatWithUsersList = [];
  //   bool _isChatAvaiable = false;
  //   if (senderchatWithUsers.length != 0 || senderchatWithUsers.isNotEmpty) {
  //     for (int i = 0; i < senderchatWithUsers.length; i++) {
  //       senderChatWithUsersList.add(senderchatWithUsers[i]);
  //       print(senderChatWithUsersList);
  //       if (senderchatWithUsers[i] == chatId) {
  //         _isChatAvaiable = true;

  //         print('is chat avaiable :: $_isChatAvaiable');
  //       }
  //       if (_isChatAvaiable == false) {
  //         senderChatWithUsersList.add(chatId);
  //       }
  //     }
  //   } else {
  //     senderChatWithUsersList.add(chatId);
  //   }
  //   print(_senderUserDetail.docs[0]['uid']);
  //   await FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.usersCollection)
  //       .doc(await _senderUserDetail.docs[0]['uid'])
  //       // .set({'chatwithusers': senderChatWithUsersList});
  //       .update({'chatwithusers': senderChatWithUsersList});

  //   // QuerySnapshot<Map<String, dynamic>> _reciverUserDetail =
  //   //     await FirebaseUserHalper().getCurrentUserDetails(email: senderEmail);
  //   // List reciverchatWithUsers = _senderUserDetail.docs[0]['chatwithusers'];
  // }

  // updateReadStatusOfMessages({reciverEmail}) async {
  //   FirebaseFirestore.instance
  //       .collection(FirebaseCollectionName.messagesCollection)
  //       .where('reciver', isEqualTo: reciverEmail)
  //       .get()
  //       .then((value) async {
  //     print(value.docs.length);
  //     for (int index = 0; index < value.docs.length; index++) {
  //       var docReference = await FirebaseFirestore.instance
  //           .collection(FirebaseCollectionName.messagesCollection)
  //           .doc('1')
  //           .update({'messageRead': true});
  //     }
  //   });
  // }
}

// ignore: constant_identifier_names
enum MessageType { TEXT, IMAGE }
