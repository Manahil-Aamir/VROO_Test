import 'dart:convert'; // Import this for JSON encoding
import 'package:http/http.dart' as http;

import '../model/notification_request.dart';

class NotificationRemoteDataSource {
  final http.Client client;

  NotificationRemoteDataSource(this.client);

  Future<void> sendNotificationToken(String token) async {
    print('fcmm, in datasource sending token');
    print(NotificationRequest(token).toJson());

    final response = await client.post(
      Uri.parse('http://10.0.2.2:8080/send-notification/test'),
      // Uri.parse('${ApiConstants.baseUrl}/send-notification/test'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(NotificationRequest(token).toJson()),
    );

    print('FCM Response status: ${response.statusCode}');
    print('FCM Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Successfully sent');
    } else {
      print('Failed to send');
      throw Exception('Failed to send notification token');
    }
  }
}
