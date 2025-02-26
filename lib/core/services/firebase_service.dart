import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/notification/domain/usecases/send_notification_token_usecase.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final SendNotificationTokenUseCase _sendTokenUseCase;

  bool _isInitialized = false;

  FirebaseService({required SendNotificationTokenUseCase sendTokenUseCase})
      : _sendTokenUseCase = sendTokenUseCase {
    initializeFCM();
  }

  Future<void> initializeFCM() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Initialize notifications
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Setup auth listener
    _auth.authStateChanges().listen((user) {
      if (user != null) _handleTokenUpdate();
    });

    // Request permissions
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupTokenManagement();
      _setupMessageHandling();
    }
  }

  Future<void> _setupTokenManagement() async {
    final token = await _messaging.getToken();
    if (token != null) await _sendTokenUseCase(token);
    
    _messaging.onTokenRefresh.listen((newToken) async {
      await _sendTokenUseCase(newToken);
    });
  }

  Future<void> _handleTokenUpdate() async {
    final token = await _messaging.getToken();
    if (token != null) await _sendTokenUseCase(token);
  }

  void _setupMessageHandling() {
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle notification tap
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    await _notifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel', // Must match manifest channel
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}