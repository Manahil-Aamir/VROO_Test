import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class HomeRepository {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
}