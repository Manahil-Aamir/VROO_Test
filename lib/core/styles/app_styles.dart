import 'package:flutter/material.dart';
import '../theme/font/font_theme.dart';

class AppStyles {
  AppStyles._();

  ///TEXT THEME
  static TextTheme getTextTheme() => TextTheme(
        labelLarge: AppFonts.headlineTextStyle.copyWith(
            fontSize: AppFonts.buttonTextSize,
            fontFamily: 'Montserrat',
            letterSpacing: 1,
            fontWeight: FontWeight.w600),
        bodyLarge: (AppFonts.bodyTextStyle).copyWith(
            fontWeight: FontWeight.w500, fontSize: AppFonts.body1TextSize),
        bodyMedium: (AppFonts.bodyTextStyle).copyWith(
            fontWeight: FontWeight.w500, fontSize: AppFonts.body2TextSize),
        bodySmall: (AppFonts.bodyTextStyle).copyWith(
            fontWeight: FontWeight.w400, fontSize: AppFonts.body3TextSize),
        displayLarge: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline1TextSize, fontWeight: FontWeight.w700),
        displayMedium: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline2TextSize, fontWeight: FontWeight.w500),
        displaySmall: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline3TextSize, fontWeight: FontWeight.w500),
        headlineLarge: AppFonts.headlineTextStyle.copyWith(
            fontSize: AppFonts.headline1TextSize,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.bold),
        headlineMedium: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline4TextSize, fontWeight: FontWeight.bold),
        headlineSmall: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline5TextSize, fontWeight: FontWeight.bold),
        titleLarge: (AppFonts.headlineTextStyle).copyWith(
            fontSize: AppFonts.headline6TextSize, fontWeight: FontWeight.bold),
      );
}
