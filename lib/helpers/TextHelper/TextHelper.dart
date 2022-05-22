import 'package:flutter/foundation.dart';

class TextHelper {
  static final TextHelper _instance = TextHelper._privateConstructor();

  TextHelper._privateConstructor() {
    if (kDebugMode) {
      print("TextHelper initialized.");
    }
  }

  factory TextHelper() {
    return _instance;
  }

  bool validateEmail(String email) {
    Pattern emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(emailPattern as String).hasMatch(email);
  }
}
