import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class D1DataSource {
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(scheduleData);
      await prefs.setString('scheduleData', jsonString);
      print('Schedule saved successfully: $jsonString'); // Debug log
    } catch (e) {
      print('Error saving schedule: $e');
      throw Exception('Failed to save schedule: $e');
    }
  }

  Future<Map<String, dynamic>?> loadSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scheduleString = prefs.getString('scheduleData');
      
      if (scheduleString != null) {
        print('Loaded schedule string: $scheduleString'); // Debug log
        final decoded = jsonDecode(scheduleString) as Map<String, dynamic>;
        print('Decoded schedule: $decoded'); // Debug log
        return decoded;
      }
      
      print('No schedule data found'); // Debug log
      return null;
    } catch (e) {
      print('Error loading schedule: $e');
      throw Exception('Failed to load schedule: $e');
    }
  }

  // Future<void> clearScheduleData() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.remove('scheduleData');
  //     print('Schedule data cleared');
  //   } catch (e) {
  //     print('Error clearing schedule: $e');
  //     throw Exception('Failed to clear schedule: $e');
  //   }
  // }
}
