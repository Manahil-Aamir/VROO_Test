import 'dart:async';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  /// Request location permissions (requires "Always" for background)
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    // If "WhileInUse", try upgrading to "Always"
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always) {
        await Geolocator.openAppSettings(); // Open settings for manual permission
        permission = await Geolocator.checkPermission();
      }
    }
    return permission == LocationPermission.always;
  }

  /// Start tracking location in the background
  Future<void> startTracking() async {
    if (_isTracking) {
      print("🚨 Tracking already running!");
      return;
    }

    print("✅ Start Tracking requested!");

    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      print("❌ Location permission denied!");
      return;
    }

    print("📌 Permissions granted. Starting foreground service...");
    
    // Initialize communication port BEFORE starting service
    FlutterForegroundTask.initCommunicationPort();

    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      ServiceRequestResult result = await FlutterForegroundTask.startService(
        notificationTitle: "Tracking Location",
        notificationText: "Your location is being tracked in the background.",
        callback: _startBackgroundTask,
      );

      if (result is! ServiceRequestSuccess) {
        print("❌ Failed to start foreground service: ${(result as ServiceRequestFailure).error}");
        return;
      }

      // Wait a bit longer before initializing the background task
      await Future.delayed(Duration(seconds: 2));
    }

    _startBackgroundTask();
    _isTracking = true;
    print("🎯 Tracking started successfully!");
  }
    
  /// Stop tracking location
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    print("✅ Stop Tracking requested!");

    await FlutterForegroundTask.saveData(key: 'stop', value: true);
    await FlutterForegroundTask.stopService();
    _isTracking = false;

    print("✅ Location tracking stopped.");
  }

  /// Background task callback (runs in a separate isolate)
  @pragma('vm:entry-point')
  static void _startBackgroundTask() {
    print("🚀 Background Task Started!");

    // Try multiple times to get the receive port
    int retryCount = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      retryCount++;
      final receivePort = FlutterForegroundTask.receivePort;
      
      if (receivePort != null) {
        print("✅ Receive port initialized successfully.");
        _listenToPort(receivePort);
        timer.cancel();
      } else {
        print("⏳ Receive port not ready. Retry attempt $retryCount...");
        
        // Initialize port again just in case
        FlutterForegroundTask.initCommunicationPort();
        
        // Stop trying after several attempts
        if (retryCount >= 5) {
          print("❌ Error: Failed to initialize receive port after multiple attempts.");
          timer.cancel();
        }
      }
    });
  }
    
  /// Listen for messages from the main isolate
  static void _listenToPort(ReceivePort receivePort) {
    print("📬 Listening for messages...");

    StreamSubscription<dynamic>? messageSub;
    StreamSubscription<Position>? positionSub;

    messageSub = receivePort.listen((message) {
      print("📩 Message received: $message");
      if (message == 'stop') {
        positionSub?.cancel();
        messageSub?.cancel();
        FlutterForegroundTask.stopService();
        print("🛑 Background task stopped.");
      }
    });

    positionSub = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      print("📍 Location Update: ${position.latitude}, ${position.longitude}");
      FlutterForegroundTask.updateService(
        notificationText: "Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
    });
  }

}
