import 'package:flutter_app/themes/darkTheme.dart';
import 'package:flutter_app/themes/lightTheme.dart';
import 'package:flutter/material.dart';

class ThemeSwitcher {
  // static bool brightTheme = false;

  static ThemeData getTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return LightTheme.getTheme();
    } else {
      return DarkTheme.getTheme();
    }
  }
}
