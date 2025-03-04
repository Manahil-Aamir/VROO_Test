import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeDataSource {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
}

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<LatLng> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    return const LatLng(24.8607, 67.0011);
  }

  @override
  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}