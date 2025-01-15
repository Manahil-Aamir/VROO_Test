import 'package:flutter/material.dart';
import '../theme/font/font_theme.dart';

class AppStyles {
  AppStyles._();

  ///TEXT THEME
  static TextTheme getTextTheme() => TextTheme(
        labelLarge: AppFonts.buttonTextStyle
            .copyWith(fontSize: AppFonts.buttonTextSize),
        bodyLarge: (AppFonts.bodyTextStyle).copyWith(
            fontWeight: FontWeight.w500, fontSize: AppFonts.body1TextSize),
        bodyMedium:
            (AppFonts.bodyTextStyle).copyWith(fontSize: AppFonts.body2TextSize),
        displayLarge: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline1TextSize, fontWeight: FontWeight.w700),
        displayMedium: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline5TextSize, fontWeight: FontWeight.w500),
        displaySmall: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline3TextSize, fontWeight: FontWeight.w500),
        headlineMedium: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline4TextSize, fontWeight: FontWeight.bold),
        headlineSmall: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline5TextSize, fontWeight: FontWeight.bold),
        titleLarge: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline6TextSize, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(fontSize: AppFonts.captionTextSize),
      );
}
