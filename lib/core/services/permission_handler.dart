import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<bool> requestContactsPermission() async {
    var status = await Permission.contacts.request();
    return status.isGranted;
  }
}
