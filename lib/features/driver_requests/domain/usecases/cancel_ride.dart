import '../repository/active_rides_repository.dart';

class CancelRide {
  final ActiveRidesDriverRepository repository;

  CancelRide(this.repository);

  Future<void> execute(String rideId) {
    return repository.cancelRide(rideId);
  }
}
