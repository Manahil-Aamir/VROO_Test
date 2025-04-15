import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  final Function(String)? _onTokenUpdate;

  FirebaseService({Function(String)? onTokenUpdate})
      : _onTokenUpdate = onTokenUpdate {
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
      alert: true,
      badge: true,
      sound: true,
      provisional: true, // For iOS - allows temporary permission
    );
    print("[FCM] Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      _setupTokenMonitoring();
      _setupNotifications();
    }
  }

  Future<void> _setupTokenMonitoring() async {
    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print("[FCM] Token refreshed: $newToken");
      _handleTokenUpdate(newToken);
    });

    // Get initial token if user is logged in
    if (_auth.currentUser != null) {
      try {
        final token = await _messaging.getToken();
        if (token != null) {
          print("[FCM] Initial token for logged-in user: $token");
          _handleTokenUpdate(token);
        }
      } catch (e) {
        print("[FCM] Error getting initial token: $e");
      }
    }

    // Monitor auth state changes
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        try {
          final token = await _messaging.getToken();
          if (token != null) {
            print("[FCM] New token after auth state change: $token");
            _handleTokenUpdate(token);
          }
        } catch (e) {
          print("[FCM] Error getting token after auth change: $e");
        }
      }
    });
  }

  void _handleTokenUpdate(String token) {
    _onTokenUpdate?.call(token);
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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    _notifications.initialize(
      const InitializationSettings(
        android: initializationSettingsAndroid,
      ),
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap when app is in foreground
        print("[FCM] Notification tapped (foreground): ${details.payload}");
      },
    );

    // Create notification channel for Android 8.0+
    _createNotificationChannel();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      print("[FCM] Foreground message: ${message.messageId}");
      _showNotification(message);
    });

    // Notification taps when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("[FCM] Notification tapped (background): ${message.data}");
    });
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      description: 'Notification channel for general updates',
      importance: Importance.max,
      playSound: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      channelDescription: 'Notification channel for general updates',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(
        message.notification?.body ?? '',
        contentTitle: message.notification?.title,
        htmlFormatBigText: true,
        summaryText: message.notification?.title,
      ),
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  // Background message handler
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("[BACKGROUND] Handling message: ${message.messageId}");

    final notifications = FlutterLocalNotificationsPlugin();

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      description: 'Notification channel for general updates',
      importance: Importance.max,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Initialize notifications
    await notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    await notifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(android: androidPlatformChannelSpecifics),
      payload: message.data.toString(),
    );
  }
}
