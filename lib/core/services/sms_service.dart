import 'package:sms_advanced/sms_advanced.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

class SmsService {
  final SmsSender sender = SmsSender();

  Future<Map<String, dynamic>> sendSosMessage(
      List<ContactModel> contacts, String sosLink) async {
    final message = "🚨 SOS Alert! I need help. Please check: $sosLink 🚨";
    final phoneNumbers = contacts.map((c) => c.number).toList();

    try {
      for (String number in phoneNumbers) {
        sender.sendSms(SmsMessage(number, message));
      }
      return {'success': true, 'message': 'SOS sent successfully'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send SOS',
        'error': e.toString()
      };
    }
  }
}
