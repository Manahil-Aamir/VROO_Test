import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class D2DataSource {
  Future<void> saveCarPreferences(Map<String, dynamic> preferencesData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('carPreferences', jsonEncode(preferencesData));
  }

  Future<Map<String, dynamic>?> loadCarPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesString = prefs.getString('carPreferences');
    return preferencesString != null ? jsonDecode(preferencesString) : null;
  }

  Future<void> clearCarPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('carPreferences');
  }
}