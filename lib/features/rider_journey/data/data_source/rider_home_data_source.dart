import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationDataSource {
  Future<LatLng> getCurrentLocation();
}

class MockLocationDataSource implements LocationDataSource {
  @override
  Future<LatLng> getCurrentLocation() async {
    // Simulate a delay
    await Future.delayed(Duration(seconds: 1));
    // Return a mock location (e.g., Karachi, Pakistan)
    return LatLng(24.8607, 67.0011);
  }
}
