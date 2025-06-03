import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/api_constants.dart';

// Background task entry point
@pragma('vm:entry-point')
void startRideTrackerCallback() {
  FlutterForegroundTask.setTaskHandler(RideTrackerTaskHandler());
}

// Task handler for background ride tracking
class RideTrackerTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStream;
  DatabaseReference? _rideRef;

  DateTime? lastUpdateTime;
  final int updateInterval = 3; // Time interval for updates in seconds

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("🚗 Ride Tracking Task Started!");

    // Initialize Firebase
    await Firebase.initializeApp();

    // Retrieve ride ID from ForegroundTask storage
    final String? rideId =
        await FlutterForegroundTask.getData<String>(key: 'rideId');
    if (rideId == null) {
      print("⚠️ No active ride ID found.");
      return;
    }

    // Get reference to this ride in Firebase
    _rideRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: ApiConstants.databaseUrl,
    ).ref().child('rides').child(rideId);

    // Start location tracking
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // Only update if moved 5 meters
      ),
    ).listen((Position position) {
      DateTime now = DateTime.now();

      // Only send updates every `updateInterval` seconds
      if (lastUpdateTime == null ||
          now.difference(lastUpdateTime!).inSeconds >= updateInterval) {
        print(
            "📍 Location Update: ${position.latitude}, ${position.longitude}");

        // Save location to Firebase
        _saveLocationToDatabase(position);

        // Send location to map view
        _updateMapView(position);

        // Update notification with current location
        FlutterForegroundTask.updateService(
          notificationText:
              "Tracking: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}",
        );

        // Update last update time
        lastUpdateTime = now;
      }
    });
  }

  // Save location to Firebase database
  Future<void> _saveLocationToDatabase(Position position) async {
    if (_rideRef == null) return;

    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await _rideRef!.child('route').child(timestamp).set({
        'lat': position.latitude,
        'lng': position.longitude,
        'heading': position.heading,
        'speed': position.speed,
        'timestamp': timestamp,
      });

      // Update current position in a separate node for easy access
      await _rideRef!.child('currentPosition').set({
        'lat': position.latitude,
        'lng': position.longitude,
        'heading': position.heading,
        'speed': position.speed,
        'timestamp': timestamp,
      });

      print("✅ Location saved to database");
    } catch (e) {
      print("❌ Failed to save location: $e");
    }
  }

  // Update map view with new position
  Future<void> _updateMapView(Position position) async {
    try {
      const MethodChannel channel =
          MethodChannel('com.example.vroo_test/ride_map');
      await channel.invokeMethod('updateVehiclePosition', {
        'lat': position.latitude,
        'lng': position.longitude,
        'heading': position.heading,
      });

      // Keep vehicle centered on map
      await channel.invokeMethod('centerOnVehicle');

      print("✅ Map view updated");
    } catch (e) {
      print("❌ Failed to update map view: $e");
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    print("⏱️ Task Repeat Event: ${timestamp.toIso8601String()}");

    final String? rideId =
        await FlutterForegroundTask.getData<String>(key: 'rideId');
    if (rideId != null) {
      await _checkRideStatus(rideId);
    }
  }

  // Check if ride is still active
  Future<void> _checkRideStatus(String rideId) async {
    try {
      final snapshot = await FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: ApiConstants.databaseUrl,
      ).ref().child('rides').child(rideId).child('status').get();

      if (snapshot.exists && snapshot.value.toString() != 'active') {
        print("🛑 Ride is no longer active. Stopping tracking.");
        FlutterForegroundTask.stopService();
      } else {
        print("✅ Ride is still active.");
      }
    } catch (e) {
      print("⚠️ Failed to check ride status: $e");
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("🛑 Ride Tracking Task Stopped");
    await _positionStream?.cancel();
    _positionStream = null;
    _rideRef = null;
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onReceiveData(Object data) {
    print("📩 Data Received in Background Task: $data");
    if (data == 'stop') {
      FlutterForegroundTask.stopService();
    }
  }
}

// Main class for real-time ride tracking
class RealTimeRideTracker {
  final String rideId;
  late DatabaseReference _rideRef;
  late StreamSubscription<DatabaseEvent> _routeSubscription;
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');

  bool _isTracking = false;
  bool _isInitialized = false;

  RealTimeRideTracker({required this.rideId}) {
    _rideRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: ApiConstants.databaseUrl,
    ).ref().child('rides').child(rideId);
  }

  // Initialize the ride tracker
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Listen for route updates from the database
    _routeSubscription = _rideRef.child('route').onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> locationData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        // Update the map view with each new location point
        _updateMapWithDatabaseLocation(locationData);
      }
    });

    _isInitialized = true;
    print("Ride tracker initialized for ride: $rideId");
  }

  // Update map with location from database
  Future<void> _updateMapWithDatabaseLocation(
      Map<String, dynamic> locationData) async {
    try {
      await _mapChannel.invokeMethod('updateVehiclePosition', {
        'lat': locationData['lat'],
        'lng': locationData['lng'],
        'heading': locationData['heading'] ?? 0.0,
      });

      // No need to center each time since we're doing it in the foreground service
      // This is only for when restoring from database

      print("✅ Map updated from database location");
    } catch (e) {
      print("❌ Failed to update map from database: $e");
    }
  }

  // Load historical route data
  Future<void> loadHistoricalRouteData() async {
    try {
      final snapshot = await _rideRef.child('route').get();
      if (snapshot.exists) {
        Map<String, dynamic> routeData =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Sort route points by timestamp
        List<MapEntry<String, dynamic>> sortedPoints = routeData.entries
            .toList()
          ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));

        // Initialize map with route data
        await _mapChannel.invokeMethod('initializeMap', {
          'routeCoords': sortedPoints
              .map((entry) => {
                    'lat': entry.value['lat'],
                    'lng': entry.value['lng'],
                  })
              .toList(),
        });

        print("✅ Historical route loaded with ${sortedPoints.length} points");
      }
    } catch (e) {
      print("❌ Failed to load historical route: $e");
    }
  }

  // Start tracking the ride
  Future<void> startTracking() async {
    if (_isTracking) return;

    // First check for location permissions
    final locationPermission = await _checkLocationPermission();
    if (!locationPermission) {
      print("❌ Location permission denied!");
      return;
    }

    // Initialize the foreground service
    await _initializeForegroundService();

    // Start the foreground service
    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      // Update ride status to active
      await _rideRef.child('status').set('active');

      // Start the foreground service
      await FlutterForegroundTask.startService(
        notificationTitle: 'Ride Tracking Active',
        notificationText: 'Tracking your journey...',
        callback: startRideTrackerCallback,
      );

      // Save ride ID to foreground task data
      await FlutterForegroundTask.saveData(key: 'rideId', value: rideId);

      _isTracking = true;
      print("🚀 Ride tracking started for ride: $rideId");
    }
  }

  // Stop tracking the ride
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    // Update ride status to completed
    await _rideRef.child('status').set('completed');

    // Stop foreground service
    FlutterForegroundTask.sendDataToTask('stop');
    FlutterForegroundTask.stopService();

    _isTracking = false;
    print("🛑 Ride tracking stopped for ride: $rideId");
  }

  // Check and request location permission
  Future<bool> _checkLocationPermission() async {
    final locationService = LocationService();
    bool hasPermission = await locationService.checkAndRequestPermission();
    print(hasPermission
        ? "✅ Location permission granted!"
        : "❌ Location permission denied!");
    if (!hasPermission) {
      print("❌ Location permissions required!");
      return false;
    }
    return true;
  }

  // Initialize foreground service
  Future<void> _initializeForegroundService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'ride_tracking_service',
        channelName: 'Ride Tracking Service',
        channelDescription: 'This service tracks location in the background.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction:
            ForegroundTaskEventAction.repeat(60000), // Runs every 1 min
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  // Clean up resources
  void dispose() {
    if (_isTracking) {
      stopTracking();
    }
    _routeSubscription.cancel();
  }
}
