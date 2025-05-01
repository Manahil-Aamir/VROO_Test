import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/api_constants.dart';

// 🔹 Background task entry point
@pragma('vm:entry-point')
void startLocationTaskCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

// 🔹 TaskHandler to manage location updates in the background
class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStream;

  DateTime? lastUpdateTime;
  final int updateInterval = 50; // Time interval for updates in seconds (10s)

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("Background Location Task Started!");
    await Firebase.initializeApp(); // Ensure Firebase is initialized

    // Retrieve sessionId from ForegroundTask storage
    final String? sessionId =
        await FlutterForegroundTask.getData<String>(key: 'sessionId');
    if (sessionId == null) {
      print("⚠️ No active session found.");
      return;
    }

    // Start location tracking with distance filter and time-based throttling
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10, // Only update if moved 10 meters
      ),
    ).listen((Position position) {
      DateTime now = DateTime.now();

      // Only send updates every `updateInterval` seconds
      if (lastUpdateTime == null ||
          now.difference(lastUpdateTime!).inSeconds >= updateInterval) {
        print(
            "📍 Location Update: ${position.latitude}, ${position.longitude}");

        // Update Firebase database
        sendLocation(sessionId, position);

        // Update notification with current location
        FlutterForegroundTask.updateService(
          notificationText:
              "Lat: ${position.latitude}, Lng: ${position.longitude}",
        );

        // Update the last time we sent a location update
        lastUpdateTime = now;
      }
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    print("⏰ Task Repeat Event: ${timestamp.toIso8601String()}");

    final String? sessionId =
        await FlutterForegroundTask.getData<String>(key: 'sessionId');
    if (sessionId != null) {
      await checkSessionStatus(sessionId);
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("🛑 Background Location Task Stopped");
    await _positionStream?.cancel();
    _positionStream = null;
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

// 🔹 Main SOS Tracker Service
class SosTrackerService {
  final String sessionId;

  SosTrackerService({required this.sessionId});

  /// Start tracking
  Future<void> startTracking() async {
    final locationService = LocationService();
    bool hasPermission = await locationService.checkAndRequestPermission();
    print(hasPermission
        ? "✅ Location permission granted!"
        : "❌ Location permission denied!");
    if (!hasPermission) {
      print("❌ Location permissions required!");
      return;
    }
    print("permission granted");

    await _initializeForegroundService();

    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      await FlutterForegroundTask.startService(
        notificationTitle: 'SOS Tracking Active',
        notificationText: 'Tracking location...',
        callback: startLocationTaskCallback,
      );
      await FlutterForegroundTask.saveData(key: 'sessionId', value: sessionId);
      print("🚀 Foreground tracking started for session: $sessionId");
    }
  }

  /// Stop tracking
  Future<void> stopTracking() async {
    FlutterForegroundTask.sendDataToTask('stop');
    FlutterForegroundTask.stopService();
    print("🛑 Tracking stopped for session: $sessionId");
    try {
      await FirebaseFirestore.instance
          .collection('sessions') // replace with your collection name
          .doc(sessionId) // the document ID from the image is "100294376586"
          .update({'status': 'inactive'});

      print("✅ Status updated to inactive for session: $sessionId");
    } catch (e) {
      print("❌ Failed to update status: $e");
    }
  }
}

/// 🔹 Initialize Foreground Service
Future<void> _initializeForegroundService() async {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'sos_foreground_service',
      channelName: 'SOS Tracking Service',
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
      eventAction: ForegroundTaskEventAction.repeat(60000), // Runs every 1 min
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

/// 🔹 Check SOS Session Status
Future<void> checkSessionStatus(String sessionId) async {
  print("🔄 Checking session status...");
  final DatabaseReference sessionRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: ApiConstants.databaseUrl,
  ).ref('sessions');

  final sessionSnapshot =
      await sessionRef.child(sessionId).child("status").get();
  if (sessionSnapshot.exists && sessionSnapshot.value != "active") {
    print("❌ SOS session ended. Stopping tracking.");
    FlutterForegroundTask.stopService();
  } else {
    print("✅ SOS session still active.");
  }
}

/// 🔹 Send Location Update to Firebase
Future<void> sendLocation(String sessionId, Position position) async {
  print("📤 Sending location...");
  final DatabaseReference sessionRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: ApiConstants.databaseUrl,
  ).ref('sessions');

  await sessionRef.child(sessionId).update({
    "lat": position.latitude,
    "long": position.longitude,
    "lastUpdated": DateTime.now().toIso8601String(),
  });

  print("Location updated: ${position.latitude}, ${position.longitude}");
}
