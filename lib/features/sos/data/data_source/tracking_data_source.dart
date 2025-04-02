import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/api_constants.dart';

class SosTrackerService {
  final String sessionId;
  StreamSubscription<Position>? _positionStream;
  Timer? _sessionTimer;

  SosTrackerService({required this.sessionId});

  Future<void> startTracking() async {
    final locationService = LocationService();
    bool hasPermission = await locationService.checkAndRequestPermission();
    if (!hasPermission) {
      print("❌ Location permissions required!");
      return;
    }

    await _initializeForegroundService();

    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      await FlutterForegroundTask.startService(
        notificationTitle: 'SOS Tracking Active',
        notificationText: 'Tracking location...',
        callback: locationUpdateCallback,
      );
      await FlutterForegroundTask.saveData(key: 'sessionId', value: sessionId);
      print("🚀 Foreground tracking started for session: $sessionId");
    }

    // Start listening for location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      sendLocation(sessionId, position);
    });

    // Check session status every 5 minutes
    _sessionTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      checkSessionStatus(sessionId);
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
    _sessionTimer?.cancel();
    FlutterForegroundTask.stopService();
    print("🛑 Tracking stopped for session: $sessionId");
  }
}

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

void locationUpdateCallback() async {
  print("⏳ Foreground task running...");
  await Firebase.initializeApp();

  final String? sessionId =
      await FlutterForegroundTask.getData<String>(key: 'sessionId');
  if (sessionId == null) {
    print("⚠️ No active session found.");
    return;
  }

  print("📍 Tracking for session: $sessionId");
  // No manual fetching, location updates handled by stream
  if (DateTime.now().minute % 5 == 0) {
    checkSessionStatus(sessionId);
  }
}

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

  print("✅ Location updated: ${position.latitude}, ${position.longitude}");
}
