import 'package:flutter/cupertino.dart';

class Helper {
  Helper._privateConstructor();
  static final Helper instance = Helper._privateConstructor();

  bool isDarkMode(context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
