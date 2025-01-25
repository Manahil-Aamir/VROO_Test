import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class D1DataSource {
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('scheduleData', jsonEncode(scheduleData));
  }

  Future<Map<String, dynamic>?> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleString = prefs.getString('scheduleData');
    if (scheduleString != null) {
      return jsonDecode(scheduleString) as Map<String, dynamic>;
    }
    return null;
  }
}
