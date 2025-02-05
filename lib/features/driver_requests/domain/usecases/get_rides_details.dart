
import '../entity/rides_details.dart';
import '../repository/rides_details_repository.dart';

class GetRideDetails {
  final RideDetailsRepository repository;

  GetRideDetails(this.repository);

  Future<List<RideDetailsEntity>> execute(String rideId) async {
    return await repository.getRideDetails(rideId);
  }
}
