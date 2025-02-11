import '../repository/matching_repository.dart';

class ModifyRideUseCase {
  final MatchingRepository repository;

  ModifyRideUseCase(this.repository);

  Future<List<dynamic>> execute(
      String rideRequestId, Map<String, dynamic> requestData) {
    return repository.requestRide(rideRequestId, requestData);
  }
}
