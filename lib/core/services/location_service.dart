import 'package:geolocator/geolocator.dart';

class LocationService {
  static bool _isRequestingPermission = false; // Prevent multiple requests

  // Checks and requests location permissions
  Future<bool> checkAndRequestPermission() async {
    if (_isRequestingPermission) return false; // Prevent duplicate requests

    _isRequestingPermission = true;
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isRequestingPermission = false;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isRequestingPermission = false;
      return false;
    }

    _isRequestingPermission = false;
    return true;
  }

  // Gets the current device location if permissions are granted
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
