import '../entity/ride_request_join.dart';
import '../repository/ride_request_join_repository.dart';

class GetPendingRideRequestJoinsUsecase {
  final RideRequestJoinRepository repository;

  GetPendingRideRequestJoinsUsecase(this.repository);

  Future<List<RideRequestJoinEntity>> call(String rideRequestId) {
    return repository.getPendingRideRequestJoins(rideRequestId);
  }
}
