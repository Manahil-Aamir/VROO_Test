import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;

  FirebaseService() {
    initializeFCM();
  }

  Future<void> initializeFCM() async {
    print("🔥 FCM Initialization STARTED");
    if (_isInitialized) {
      print("⚠️ FCM Already initialized");
      return;
    }
    _isInitialized = true;

    print("[FCM] Initializing service...");

    // Request permissions
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print("[FCM] Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _setupNotifications();
    }
  }

  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print("[FCM] Error getting token: $e");
      return null;
    }
  }

  void _setupNotifications() {
    // Initialize notifications
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print("[FCM] Foreground message: ${message.messageId}");
      _showNotification(message);
    });

    // Notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("[FCM] Notification tapped: ${message.data}");
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    await _notifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Background message handler
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("[BACKGROUND] Handling message: ${message.messageId}");
    
    final notifications = FlutterLocalNotificationsPlugin();
    await notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await notifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
