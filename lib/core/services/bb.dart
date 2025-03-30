import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Timer? _timer;
  Position? _lastPosition;

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Start tracking location in the background
  void startTracking() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      print("❌ Location permission denied!");
      return;
    }

    // Start Foreground Task
    FlutterForegroundTask.startService(
      notificationTitle: "Tracking Location",
      notificationText: "Your location is being tracked in the background.",
      callback: _startBackgroundTask,
    );

    // Start location updates every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (_) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Log every 10 seconds, even if position is the same
      print("📍 Location Update: ${position.latitude}, ${position.longitude}, ${DateTime.now()}");

      // Store last position (optional)
      _lastPosition = position;
    });
  }

  /// Stop tracking location
  void stopTracking() {
    _positionStream?.cancel();
    _timer?.cancel();
    FlutterForegroundTask.stopService();
    print("🚫 Location tracking stopped.");
  }

  /// Background task callback
  static void _startBackgroundTask() {
    LocationService().startTracking();
  }
}
