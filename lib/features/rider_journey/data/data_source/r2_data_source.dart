import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class R2DataSource {
  // Save the preference data with boolean values
  Future<void> savePreference(Map<String, dynamic> preferenceData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('preferenceData', jsonEncode(preferenceData));
  }

  // Load the preference data and return as Map<String, bool>
  Future<Map<String, dynamic>?> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final preferenceString = prefs.getString('preferenceData');
    if (preferenceString != null) {
      return Map<String, bool>.from(jsonDecode(preferenceString));
    }
    return null;
  }
}
