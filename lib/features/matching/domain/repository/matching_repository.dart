abstract class MatchingRepository {
  Future<Map<String, dynamic>> sendRequest(Map<String, String> rideData);
  Future<List<dynamic>> requestRide(
      String rideRequestId, Map<String, dynamic> requestData);
}
