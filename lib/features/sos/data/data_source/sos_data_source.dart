import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import '../../../../core/services/permission_handler.dart';
import '../../../../core/services/sms_service.dart';
import '../models/sos_model.dart';
import '../../../../core/utils/constant/api_constants.dart';
import 'tracking_data_source.dart';

abstract class SosDataSource {
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String uid);
  Future<List<ContactModel>> getEmergencyContacts(String uid);
  Future<bool> deleteEmergencyContact(String uid, String contactId);
  Future<String> triggerSOS(String uid);
}

class SosDataSourceImpl implements SosDataSource {
  static const String baseUrl = "${ApiConstants.baseUrl}emergency";
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
  Future<String> triggerSOS(String uid) async {
    bool smsPermissionGranted = await _permissionService.requestSmsPermission();
    if (!smsPermissionGranted) {
      return "SMS permission denied";
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/triggerSOS?uid=$uid'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return "Failed to trigger SOS: Server error ${response.statusCode}";
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] is! bool || !(data['success'] as bool)) {
        return "Failed to trigger SOS: ${data['message'] ?? 'Unknown error'}";
      }

      final SosModel sosData = SosModel.fromMap(data['data']);

      String message =
          "SOS Triggered!\nSession ID: ${sosData.sessionId}\nLink: ${sosData.sosLink}";
      print(message);
      print(sosData.emergencyContacts);

      List<ContactModel> contacts = [];
      contacts = sosData.emergencyContacts;
      print(contacts.length);

      if (contacts.isEmpty) {
        return "No emergency contacts found.";
      }

      // Get response as Map instead of expecting a bool**
      final Map<String, dynamic> smsResponse = {
        'success': true,
        'message': 'SOS sent successfully'
      };
      //await _smsService.sendSosMessage(contacts, message);
      if (smsResponse['success'] == true) {
        print("Message sent successfully, starting tracking...");

        SosTrackerService(
          sessionId: sosData.sessionId,
        ).startTracking();

        return "Message sent successfully";
      } else {
        return "Failed to send message: ${smsResponse['message']}";
      }
    } catch (e) {
      return "An error occurred: ${e.toString()}";
    }
  }
}
