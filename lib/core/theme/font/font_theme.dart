import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFonts {
  AppFonts._();

  static TextStyle get robotoFontType => const TextStyle(fontFamily: 'Roboto');

  static TextStyle get headlineTextStyle => robotoFontType;
  static TextStyle get bodyTextStyle => robotoFontType;
  static TextStyle get buttonTextStyle => robotoFontType;
  static TextStyle get appBarTextStyle => robotoFontType;
  static TextStyle get chipTextStyle => robotoFontType;

  static double get appBarTitleSize => 18.sp;

  static double get headline1TextSize => 28.sp;
  static double get headline2TextSize => 24.sp;

  static double get body1TextSize => 16.sp;
  static double get body2TextSize => 17.sp;
  static double get body3TextSize => 12.sp;

  static double get headline3TextSize => 28.sp;
  static double get headline4TextSize => 18.sp;
  static double get headline5TextSize => 16.sp;
  static double get headline6TextSize => 14.sp;

  static double get buttonTextSize => 16.sp;
  static double get captionTextSize => 12.sp;
  static double get chipTextSize => 10.sp;
}
