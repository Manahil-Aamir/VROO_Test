import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/utils/constant/api_constants.dart'; // Import Firebase core

class CoordsDataSource {
  final FirebaseDatabase _firebaseDatabase;

  CoordsDataSource({FirebaseDatabase? firebaseDatabase})
      : _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;

  Future<List<List<double>>> fetchRouteCoordinates(String rideId) async {
    final rideRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: ApiConstants.databaseUrl,
    ).ref().child('rides').child(rideId);
    final ref = rideRef.child('route');
    DataSnapshot snapshot = await ref.get();
    print(snapshot.exists ? 'Data exists' : 'No data found');
    print('Snapshot value: ${snapshot.value}');

    if (snapshot.exists) {
      Map<dynamic, dynamic> routeData = snapshot.value as Map<dynamic, dynamic>;
      List<List<double>> coords = [];
      print('Route data: $routeData');

      routeData.forEach((timestamp, location) {
        if (location != null &&
            location['lat'] != null &&
            location['lng'] != null) {
          coords.add([
            location['lat'].toDouble(),
            location['lng'].toDouble(),
          ]);
        }
      });

      return coords;
    } else {
      return [];
    }
  }
}
