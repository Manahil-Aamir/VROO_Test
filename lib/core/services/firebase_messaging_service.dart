// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseMessagingService {
//   // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initSettings =
//         InitializationSettings(android: androidInitSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initSettings);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         _showNotification(message.notification!);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Notification clicked: ${message.data}");
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print("Handling a background message: ${message.messageId}");
//     print("Background message received: ${message.messageId}"); // <-- Add this logging point
//     print("Notification Title: ${message.notification?.title}"); // <-- Optional: Log notification title
//     print("Notification Body: ${message.notification?.body}"); // <-- Optional: Log notification body
//     print("Data Payload: ${message.data}"); // <-- Optional: Log data payload
//   }

//   static Future<void> _showNotification(RemoteNotification notification) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       notificationDetails,
//     );
//   }
// }
