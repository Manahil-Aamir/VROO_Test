import 'dart:convert'; // Import this for JSON encoding
import 'package:http/http.dart' as http;

import '../model/notification_request.dart';

class NotificationRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://10.0.2.2:3000';

  NotificationRemoteDataSource(this.client);

  Future<void> sendNotificationToken(String token) async {
    print('fcmm, in datasource sending token');
    print(NotificationRequest(token).toJson());

    final response = await client.post(
      Uri.parse('$baseUrl/send-notification/test'),
      headers: {'Content-Type': 'application/json'}, // Add JSON headers
      body: jsonEncode(NotificationRequest(token).toJson()), // Encode the body properly
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Successfully sent');
    } else {
      print('Failed to send');
      throw Exception('Failed to send notification token');
    }
  }
}
