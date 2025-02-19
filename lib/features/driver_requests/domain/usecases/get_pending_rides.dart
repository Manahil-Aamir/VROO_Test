
import '../entity/pending_rides.dart';
import '../repository/pending_rides_repository.dart';

class GetPendingRides {
  final PendingRidesRepository repository;

  GetPendingRides(this.repository);

  Future<List<PendingRidesEntity>> execute(String rideId) async {
    return await repository.getPendingRides(rideId);
  }
}
