import '../entity/rides_details.dart';

abstract class RideDetailsRepository {
  Future<List<RideDetailsEntity>> getRideDetails(String rideId);
}
