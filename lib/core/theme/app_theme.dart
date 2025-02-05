import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'color/color_theme.dart';

class AppTheme {
  AppTheme._();
  static getThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      //Main Color (AppBar,Tabs..etc)
      primaryColor: ThemeColors.primaryColor,
      primaryColorLight: ThemeColors.primaryColorLight,
      primaryColorDark: ThemeColors.primaryColorDark,
      scaffoldBackgroundColor: ThemeColors.scaffoldBackgroundColor,

      indicatorColor: ThemeColors.accentColor,

      //Canvas Color
      canvasColor: ThemeColors.canvasColor,

      //Card Background Color
      cardColor: ThemeColors.cardColor,

      //Hint Text Color
      hintColor: ThemeColors.hintTextColor,

      //Divider Color
      dividerColor: ThemeColors.dividerColor,

      //Text Theme
      textTheme: AppStyles.getTextTheme(),
      // colorScheme: ColorScheme.fromSwatch().copyWith(
      //     secondary: LightThemeColors.accentColor),
    );
  }
}
