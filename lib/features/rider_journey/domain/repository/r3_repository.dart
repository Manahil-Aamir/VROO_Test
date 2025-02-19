import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';

abstract class R3Repository {
  Future<LatLng> getCoordinates(String placeId);
  Future<RideResponseModel> requestRide(Map<String, dynamic> requestData);
}
