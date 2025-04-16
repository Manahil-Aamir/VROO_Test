// phone_service.dart
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneService {
  static Future<bool> _checkAndRequestPhonePermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    try {
      final hasPermission = await _checkAndRequestPhonePermission();
      
      if (!hasPermission) {
        throw 'Phone permission denied';
      }

      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      throw 'Failed to make phone call: $e';
    }
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
