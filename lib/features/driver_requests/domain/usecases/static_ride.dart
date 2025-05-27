import 'package:vroo_test/features/driver_requests/domain/repository/active_rides_repository.dart';

import '../../../ride_start/data/models/ridestart_data_model.dart';

class GetRideData {
  final ActiveRidesDriverRepository repository;
  GetRideData(this.repository);

  Future<RidestartDataModel> call(String rideId, String token) async {
    final rideData = await repository.getRideData(rideId, token);
    return rideData;
  }
}
