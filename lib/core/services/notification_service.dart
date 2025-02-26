// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     const AndroidInitializationSettings androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidInitSettings);

//     _localNotificationsPlugin.initialize(initSettings);
//   }

//   static void showNotification(RemoteMessage message) {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       "channelId",
//       "channelName",
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     _localNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }
// }