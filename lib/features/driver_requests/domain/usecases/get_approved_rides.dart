
import '../entity/approved_rides.dart';
import '../repository/approved_rides_repository.dart';

class GetApprovedRides {
  final ApprovedRidesRepository repository;

  GetApprovedRides(this.repository);

  Future<List<ApprovedRidesEntity>> execute(String rideId) async {
    return await repository.getApprovedRides(rideId);
  }
}
