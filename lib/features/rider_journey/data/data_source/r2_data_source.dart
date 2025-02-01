import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class R2DataSource {
  Future<void> savePreference(Map<String, dynamic> preferenceData) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('preferenceData', jsonEncode(preferenceData));
  }

  Future<Map<String, dynamic>?> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final preferenceString = prefs.getString('preferenceData');
    if (preferenceString != null) {
      return jsonDecode(preferenceString) as Map<String, dynamic>;
    }
    return null;
  }
}
