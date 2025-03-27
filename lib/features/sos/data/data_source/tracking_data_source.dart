import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/constant/api_constants.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';

final FlutterBackgroundService _backgroundService = FlutterBackgroundService();

class SosTrackerService {
  final String sessionId;

  SosTrackerService({required this.sessionId});

  Future<void> startTracking() async {
    final LocationService locationService = LocationService();
    bool hasPermission = await locationService.checkAndRequestPermission();

    if (!hasPermission) {
      print("Location permissions are required to start tracking");
      return;
    }

    if (!(_backgroundService.isRunning() == true)) {
      await _initializeBackgroundService();
      await Future.delayed(const Duration(seconds: 3));
    }

    _backgroundService.invoke("startTracking", {"sessionId": sessionId});
    print("Background tracking started for session: $sessionId");
  }

  void stopTracking() {
    _backgroundService.invoke("stopTracking");
    print("Background tracking stopped for session: $sessionId");
  }
}

Future<void> _initializeBackgroundService() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  await _backgroundService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onBackgroundServiceStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: "sos_tracking",
      initialNotificationTitle: "SOS Tracking Active",
      initialNotificationContent: "Tracking your location...",
      foregroundServiceTypes:
          Platform.isAndroid && androidInfo.version.sdkInt >= 34
              ? [AndroidForegroundType.location] // Required for Android 14+
              : null, // Ignore for Android 13 and below
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onBackgroundServiceStart,
      onBackground: onBackgroundServiceStart,
    ),
  );

  await _backgroundService.startService();
  print("Background service initialized and started");
}

FutureOr<bool> onBackgroundServiceStart(ServiceInstance service) async {
  print("Background service started");

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("Firebase initialized in background service");
  } catch (e) {
    print("Error initializing Firebase in background service: $e");
  }

  if (service is AndroidServiceInstance) {
    service.on("stopTracking").listen((event) {
      print("Stopping tracking");
      service.stopSelf();
      print("Background service stopped.");
    });
  }

  service.on("startTracking").listen((event) {
    print('Handle startTracking event');
    String? sessionId = event?["sessionId"];
    print("Tracking started for session: $sessionId");

    if (sessionId != null) {
      Timer.periodic(const Duration(minutes: 6), (timer) async {
        await checkSessionStatus(sessionId);
      });

      Timer.periodic(const Duration(minutes: 2), (timer) async {
        Position? position = await getCurrentLocation();
        if (position != null) {
          await sendLocation(sessionId, position);
        }
      });
    }
  });

  return true;
}

Future<void> checkSessionStatus(String sessionId) async {
  print('Checking session status...');
  final DatabaseReference sessionRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: ApiConstants.databaseUrl,
  ).ref('sessions');

  final sessionSnapshot =
      await sessionRef.child(sessionId).child("status").get();
  if (sessionSnapshot.exists && sessionSnapshot.value != "active") {
    print("SOS session ended. Stopping tracking");
    _backgroundService.invoke("stopTracking");
  } else {
    print('SOS session is still active.');
  }
}

Future<void> sendLocation(String sessionId, Position position) async {
  print('Sending location...');
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

Future<Position?> getCurrentLocation() async {
  print('fetching locationnn');
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (e) {
    print("Error getting location: $e");
    return null;
  }
}
