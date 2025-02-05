import '../entity/ride_request.dart';
import '../repository/ride_request_repository.dart';

class SubmitRideRequest {
  final RideRepository repository;

  SubmitRideRequest(this.repository);

  Future<void> call(RideRequest request) {
    return repository.submitRideRequest(request);
  }
}
