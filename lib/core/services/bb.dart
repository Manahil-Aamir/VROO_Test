import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

// Define a top-level function as the entry point for the background task
@pragma('vm:entry-point')
void startLocationTaskCallback() {
  // The background task initialization requires a top-level function
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

// Implement the TaskHandler for handling background location updates

class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStream;
  
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("🚀 Background Location Task Started!");
    
    // Start location tracking
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      print("📍 Location Update: ${position.latitude}, ${position.longitude} , ${DateTime.now()}");
      
      // Update the notification with the current location
      FlutterForegroundTask.updateService(
        notificationText: "Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
      
      // Send data to the main isolate if needed
      FlutterForegroundTask.sendDataToMain({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }
  
  @override
  void onRepeatEvent(DateTime timestamp) {
    // This will be called based on the interval specified in ForegroundTaskOptions
    print("⏰ Task Repeat Event: ${timestamp.toIso8601String()}");
  }
  
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("🛑 Background Location Task Stopped");
    await _positionStream?.cancel();
    _positionStream = null;
    
    // Clean up any resources here
    await FlutterForegroundTask.clearAllData();
  }
  
  @override
  void onReceiveData(Object data) {
    // Handle data received from the main isolate
    print("📩 Data Received in Background Task: $data");
    
    // Check if we should stop the task
    if (data == 'stop') {
      FlutterForegroundTask.stopService();
    }
  }
}

// Main service class to be used from your app
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

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

  /// Initialize and check required prerequisites
  Future<void> initialize() async {
    // Initialize FlutterForegroundTask
    await _initForegroundTask();
    
    // Register for data updates from background task
    FlutterForegroundTask.addTaskDataCallback((data) {
      print("✉️ Data received from background task: $data");
    });
  }

  Future<void> _initForegroundTask() async {
  // Initialize FlutterForegroundTask
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_foreground_service',
        channelName: 'Location Tracking Service',
        channelDescription: 'This notification appears when the service is running',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),  // Add this line
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
  /// Start tracking location in the background
  Future<bool> startTracking() async {
    if (_isTracking) {
      print("🚨 Tracking already running!");
      return true;
    }

    print("✅ Start Tracking requested!");

    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      print("❌ Location permission denied!");
      return false;
    }

    print("📌 Permissions granted. Starting foreground service...");
    
    // Initialize communication port for receiving data from the background task
    FlutterForegroundTask.initCommunicationPort();
    
    // Check if service is already running
    bool isRunning = await FlutterForegroundTask.isRunningService;
    if (!isRunning) {
      // Start the service
      final result = await FlutterForegroundTask.startService(
        notificationTitle: "Location Tracking",
        notificationText: "Tracking your location in background",
        callback: startLocationTaskCallback,
      );
      
      if (result is ServiceRequestFailure) {
        print("❌ Failed to start foreground service: ${result.error}");
        return false;
      }
    }

    _isTracking = true;
    print("🎯 Tracking started successfully!");
    return true;
  }
    
  /// Stop tracking location
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    print("✅ Stop Tracking requested!");
    
    // Send stop signal to background task
    FlutterForegroundTask.sendDataToTask('stop');
    
    // Also try to stop directly in case communication fails
    await FlutterForegroundTask.stopService();
    _isTracking = false;

    print("✅ Location tracking stopped.");
  }
  
  /// Check if tracking is currently active
  Future<bool> isTracking() async {
    final isRunning = await FlutterForegroundTask.isRunningService;
    _isTracking = isRunning;
    return isRunning;
  }
}