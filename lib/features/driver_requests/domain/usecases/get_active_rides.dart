import '../entity/active_ride.dart';
import '../repository/active_rides_repository.dart';

class GetActiveRidesDriver {
  final ActiveRidesDriverRepository repository;

  GetActiveRidesDriver(this.repository);

  Future<List<ActiveRideEntity>> execute() async {
    return await repository.getActiveRidesDriver();
  }
}
