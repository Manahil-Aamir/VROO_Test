import '../entity/active_ride.dart';
import '../repository/active_rides_repository.dart';

class GetActiveRides {
  final ActiveRidesRepository repository;

  GetActiveRides(this.repository);

  Future<List<ActiveRideEntity>> execute(String driverId) async {
    return await repository.getActiveRides(driverId);
  }
}