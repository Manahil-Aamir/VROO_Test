import 'package:flutter_sms/flutter_sms.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

class SmsService {
  Future<Map<String, dynamic>> sendSosMessage(
      List<ContactModel> contacts, String message) async {
    final phoneNumbers = contacts.map((c) => c.number).toList();

    print(
        'Debug: Preparing to send SOS message to ${phoneNumbers.length} contacts.');

    try {
      String result = await sendSMS(
        message: message,
        recipients: phoneNumbers,
        sendDirect:
            true, // Change to false if you want the user to confirm before sending
      );

      print('Debug: SMS Result - $result');
      return {'success': true, 'message': 'SOS sent successfully'};
    } catch (e) {
      print('Debug: Error occurred while sending SOS messages: $e');
      return {
        'success': false,
        'message': 'Failed to send SOS',
        'error': e.toString()
      };
    }
  }
}
