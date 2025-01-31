import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class RiderHomeRepository {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
}
