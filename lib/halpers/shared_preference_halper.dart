// ignore_for_file: prefer_conditional_assignment, avoid_print

import 'package:one_to_one_chat_with_firestore/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHalper {
  /// Note:- pref use at once
  static SharedPreferences? pref;

  ///

  static Future<SharedPreferences> getPrefObject() async {
    if (pref == null) pref = await SharedPreferences.getInstance();
    return pref!;
  }

  bool _userVisited = false;
  bool get userVisited => _userVisited;
  String _email = '';
  String get email => _email;

  getInitValues() async {
    await getUserIsVisited();
    await getUserEmail();
  }

  Future<bool> getUserIsVisited() async {
    pref = await getPrefObject();
    _userVisited = pref!.getBool(SharedPreferenceKeys.userVisitedkey) ?? false;
    print("user visited : $_userVisited");
    return _userVisited;
  }

  setUserIsVisited() async {
    pref = await getPrefObject();
    pref!.setBool(SharedPreferenceKeys.userVisitedkey, true);
  }

  clearUserIsVisited() async {
    pref = await getPrefObject();
    pref!.remove(SharedPreferenceKeys.userVisitedkey);
    clearUserEmail();
  }

  Future<String?> getUserEmail() async {
    pref = await getPrefObject();
    // _email =
    return pref!.getString(SharedPreferenceKeys.userEmailKey) ?? " ";
  }

  setUserEmail({required String email}) async {
    pref = await getPrefObject();
    pref!.setString(SharedPreferenceKeys.userEmailKey, email);
  }

  clearUserEmail() async {
    pref = await getPrefObject();
    pref!.remove(SharedPreferenceKeys.userVisitedkey);
  }
}
