import '../../data/models/matching_rides_model.dart';

abstract class MatchingRepository {
  Future<Map<String, dynamic>> sendRequest(Map<String, String> rideData);
  Future<List<dynamic>> requestRide(String rideRequestId, Map<String, dynamic> requestData);
  Future<List<MatchingRideModel>> getRideRequestMatches(String rideRequestId);
}
