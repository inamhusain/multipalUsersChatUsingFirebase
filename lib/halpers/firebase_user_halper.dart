import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_to_one_chat_with_firestore/utils.dart';

class FirebaseUserHalper {
  String currentUser = '';
  getCurrentUserDetails({email}) async {
    QuerySnapshot<Map<String, dynamic>> _userDetails = await FirebaseFirestore
        .instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    return _userDetails;
  }

  final Stream<QuerySnapshot> allUsersStream = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.usersCollection)
      .orderBy('username', descending: false)
      .snapshots();
}
