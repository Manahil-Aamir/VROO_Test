import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print("🔍 Current Permission: $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Permission Denied");
        return false;
      }
    }

    // If "WhileInUse" is granted, ask for "Always"
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();

      // If "Always" is still not granted, open settings
      if (permission != LocationPermission.always) {
        print("⚠️ Opening app settings to enable Always permission...");
        await Geolocator.openAppSettings();

        // 🔁 Wait & re-check permission a few times (since settings don’t return a result)
        await Future.delayed(
            Duration(seconds: 3)); // Give user time to change setting

        for (int i = 0; i < 3; i++) {
          // Retry checking permission a few times
          permission = await Geolocator.checkPermission();
          print("🔄 Retrying permission check: $permission");

          if (permission == LocationPermission.always) {
            print("✅ 'Always' Permission Granted!");
            return true;
          }
          await Future.delayed(
              Duration(seconds: 2)); // Small delay before next check
        }
      }
    }

    //print("❌ Final Permission: $permission (Not Always)");
    return permission == LocationPermission.always;
  }

  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
