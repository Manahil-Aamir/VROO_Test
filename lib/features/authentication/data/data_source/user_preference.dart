import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/user_model.dart';

class UserPreferences {
  static const _keyUser = 'user_data';

  static String get userKey => _keyUser;

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUser, userJson);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('Error reading user from SharedPrefs: $e');
      return null;
    }
  }

  // static Future<void> clearUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_keyUser);
  // }
}
