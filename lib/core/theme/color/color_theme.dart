import 'package:flutter/material.dart';

abstract class ThemeColors {
  //LIGHT SWATCH
  static const primaryColor = Color(0xFFEC8825);
  static const primaryColorDark = Color(0xFF434143);
  static const primaryColorLight = Color(0xFFB8B8B8);
  static const secondaryColor = Color(0xFF03C04A);
  static const accentColor = Color(0xFFFF324B);
  static const canvasColor = Color(0xFFF3F5F7);

  //APPBAR
  static const appBarColor = Colors.transparent;

  //SCAFFOLD
  static const scaffoldBackgroundColor = Colors.white;
  static const backgroundColor = Colors.white;
  static const dividerColor = Color(0xFFF1F1F5);
  static const cardColor = Color.fromARGB(255, 230, 230, 231);

  //ICONS
  static const appBarIconsColor = Color(0xFF06161C);
  static const iconColor = Color(0xFFDBDBDB);

  //BUTTON
  static const buttonColor = primaryColor;
  static const buttonTextColor = Colors.white;
  static const buttonDisabledColor = Colors.grey;
  static const buttonDisabledTextColor = Colors.black;

  //TEXT
  static const bodyTextColor = Color(0xFF979899);
  static const headlinesTextColor = Color(0xFF06161C);
  static const headlinesTextColorTwo = Color(0xFF617986);
  static const captionTextColor = Colors.grey;
  static const hintTextColor = Color(0xFF979899);

  // progress bar indicator
  static const progressIndicatorColor = primaryColor;
}
