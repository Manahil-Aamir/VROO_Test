import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

import '../../../../core/services/permission_handler.dart';
import '../../../../core/services/sms_service.dart';
import '../models/sos_model.dart';

abstract class SosDataSource {
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String uid);
  Future<List<ContactModel>> getEmergencyContacts(String uid);
  Future<bool> deleteEmergencyContact(String uid, String contactId);
  Future<void> triggerSOS(String uid);
}

class SosDataSourceImpl implements SosDataSource {
  static const String baseUrl = "http://10.0.2.2:3000/emergency";
  final SmsService _smsService = SmsService();
  final PermissionService _permissionService = PermissionService();

  @override
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String uid) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addEmergencyContact'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": contact.name,
        "phoneNumber": contact.number,
        "uid": uid,
      }),
    );
    print(response.body);

    final data = jsonDecode(response.body);
    if (data['success']) {
      print("Successfully added emergency contact.");
    } else {
      print("Failed to add emergency contact.");
      if (data.containsKey('error')) {
        print("Error: ${data['error']}");
      }
    }
    return {
      "message": data['message'],
      "success": data['success'],
      "error": data.containsKey('error') ? data['error'] : null,
    };
  }

  @override
  Future<List<ContactModel>> getEmergencyContacts(String uid) async {
    print('getting contacts datasource');
    //print("Sending UID: $uid");

    final response = await http.get(
      Uri.parse('$baseUrl/getEmergencyContacts?uid=$uid'),
      headers: {"Content-Type": "application/json"},
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Headers: ${response.headers}");
    print("Response Body: ${response.body}");

    if (!response.headers["content-type"]!.contains("application/json")) {
      print("Unexpected response format: ${response.headers["content-type"]}");
      return [];
    }

    late final Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      print("Error decoding response: $e");
      return [];
    }

    print("Parsed Data: $data");

    if (data['success']) {
      print("Successfully retrieved emergency contacts.");
      return (data['data']['emergencyContacts'] as List)
          .map((e) => ContactModel.fromMap(e))
          .toList();
    } else {
      print("Failed to retrieve emergency contacts.");
      return [];
    }
  }

  @override
  Future<bool> deleteEmergencyContact(String uid, String contactId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deleteEmergencyContact'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"uid": uid, "contactId": contactId}),
    );
    print('delete response');
    print(response.body);

    final data = jsonDecode(response.body);
    if (data['success']) {
      print("Successfully deleted emergency contact.");
    } else {
      print("Failed to delete emergency contact.");
    }
    return data['success'];
  }

  @override
  Future<void> triggerSOS(String uid) async {
    // 🔥 Check SMS permission before sending messages
    bool smsPermissionGranted = await _permissionService.requestSmsPermission();
    if (!smsPermissionGranted) {
      print("SMS permission denied.");
      throw Exception("SMS permission denied");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/triggerSOS'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"uid": uid}),
    );

    final data = jsonDecode(response.body);
    if (!data['success']) {
      print("Failed to trigger SOS.");
      throw Exception("Failed to trigger SOS");
    }

    print("Successfully triggered SOS.");
    final SosModel sosData = SosModel.fromMap(data['data']);
    await _smsService.sendSosMessage(
      sosData.emergencyContacts
          .map((e) => ContactModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      sosData.sosLink,
    );
  }
}
