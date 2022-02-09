import 'package:one_to_one_chat_with_firestore/halpers/firebase_auth_handler.dart';

class AuthExceptionHandler {
  static handleException(e) {
    var _exStatus;
    switch (e.code) {
      case "wrong-password":
        _exStatus = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        _exStatus = AuthResultStatus.userNotFound;
        break;
      case "invalid-email":
        _exStatus = AuthResultStatus.invalidEmail;
        break;
      case "email-already-in-use":
        _exStatus = AuthResultStatus.emailAlredyInUse;
        break;
      case "weak-password":
        _exStatus = AuthResultStatus.weakpassword;
        break;
      default:
        _exStatus = AuthResultStatus.unknownError;
        break;
    }
    return _exStatus;
  }

  static exceptionMessage({authStatus}) {
    String errorMessage;
    switch (authStatus) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.unknownError:
        errorMessage = "An undefined Error happened.";
        break;
      case AuthResultStatus.emailAlredyInUse:
        errorMessage = "Email Is already in use";
        break;
      case AuthResultStatus.weakpassword:
        errorMessage = "Weak Password";
        break;
      default:
        errorMessage = "Somthing went wrong";
        break;
    }
    return errorMessage;
  }
}
