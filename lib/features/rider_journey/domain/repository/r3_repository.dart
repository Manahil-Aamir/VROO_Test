import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class R3Repository {
  Future<LatLng> getCoordinates(String placeId);
  Future<Map<String, dynamic>> requestRide(Map<String, dynamic> requestData);
}
