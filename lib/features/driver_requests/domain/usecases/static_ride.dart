import 'package:vroo_test/features/driver_requests/domain/repository/active_rides_repository.dart';
import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';

class GetRideData {
  final ActiveRidesDriverRepository repository;
  GetRideData(this.repository);

  Future<RideStartModel> call(String rideId, String token) async {
    final rideData = await repository.getRideData(rideId, token);
    return rideData;
  }
}
