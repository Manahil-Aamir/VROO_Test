import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DriverHomeRepository {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
}
