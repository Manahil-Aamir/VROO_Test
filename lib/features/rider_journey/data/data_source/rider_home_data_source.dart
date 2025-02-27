import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RiderHomeDataSource {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
}

class MockLocationDataSource implements RiderHomeDataSource {
  @override
  Future<LatLng> getCurrentLocation() async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 1));
    // Return a mock location (e.g., Karachi, Pakistan)
    return LatLng(24.8607, 67.0011);
  }

  @override
  Future<void> clearSharedPreferences() async {
    print('hello');
    try {
      print('hi');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('SharedPreferences cleared successfully');
    } catch (e) {
      print('Failed to clear SharedPreferences: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Failed to log out: $e');
    }
  }
}
