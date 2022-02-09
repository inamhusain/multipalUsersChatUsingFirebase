// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:one_to_one_chat_with_firestore/halpers/firebase_chat_halper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHalper {
  sendImage({isLoading, id, sender, reciver, username}) async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (result != null) {
        isLoading.value = true;

        final _path = result.files.single.path;
        File _file = File(_path!);
        final dir = await Directory.systemTemp;
        final targetPath = dir.absolute.path + "/${_path.split('/').last}";
        var compressedFile = await FlutterImageCompress.compressAndGetFile(
            _path, targetPath,
            quality: 90);
        var compressImagePath = compressedFile!.path;
        // var compressImageSize =
        //     ((File(compressImagePath)).lengthSync() / 1024 / 1024)
        //             .toStringAsFixed(2) +
        //         " Mb";
        String _fileName = compressImagePath.split('/').last;
        String _destination = '$sender-Chat-Images/$_fileName';
        var uplodeTask = FirebaseChatHalper().firebaseUplodeImage(
            destination: _destination, file: File(compressImagePath));
        if (uplodeTask != null) {
          final snapshot =
              await uplodeTask.whenComplete(() => {isLoading.value = false});
          final imageUrl = await snapshot.ref.getDownloadURL();
          FirebaseChatHalper().sendChat(
            userName: username,
            index: id,
            message: imageUrl,
            messageType: MessageType.IMAGE,
            sender: sender,
            reciver: reciver,
          );
        }
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
