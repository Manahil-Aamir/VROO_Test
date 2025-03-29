import '../entity/approved_rides.dart';

abstract class ApprovedRidesRepository {
  Future<List<ApprovedRidesEntity>> getApprovedRides(String rideId);
}
