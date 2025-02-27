import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/notification/domain/usecases/send_notification_token_usecase.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  late final SendNotificationTokenUseCase _sendTokenUseCase;
  
  String? _currentToken;
  bool _isInitialized = false;

  FirebaseService({
    required SendNotificationTokenUseCase sendTokenUseCase,
  }) : _sendTokenUseCase = sendTokenUseCase {
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
    
    // Setup auth listener
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print("[AUTH] User logged in: ${user.uid}");
        _handleTokenForUser(user);
      } else {
        print("[AUTH] User logged out");
      }
    });

    print("🔑 Current User Status: ${_auth.currentUser != null ? "Logged In" : "Not Logged In"}");

    // Request permissions
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print("[FCM] Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupTokenManagement();
      _setupNotifications();
    }
  }

  Future<void> _setupTokenManagement() async {
    // Get initial token
    _currentToken = await _messaging.getToken();
    print("[FCM] Initial token: $_currentToken");
    _sendTokenToBackend();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print("[FCM] Token refreshed: $newToken");
      _currentToken = newToken;
      _sendTokenToBackend();
    });
  }

  void _handleTokenForUser(User user) {
    if (_currentToken != null) {
      print("[FCM] Sending token for logged-in user: ${user.uid}");
      _sendTokenToBackend();
    }
  }

  Future<void> _sendTokenToBackend() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("[FCM] No user logged in - storing token temporarily");
      return;
    }

    try {
      print("[FCM] Sending token to backend for ${user.uid}");
      await _sendTokenUseCase(_currentToken!);
      print("[FCM] Token successfully sent to backend");
    } catch (e) {
      print("[FCM] Error sending token: $e");
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
}