abstract class MatchingRepository {
  Future<Map<String, dynamic>> sendRequest(Map<String, String> rideData);
  Future<Map<String, dynamic>> requestRide(Map<String, dynamic> requestData);
}
