import 'package:vroo_test/features/driver_requests/domain/entity/active_ride.dart';

import '../../../ride_start/data/models/ride_start_model.dart';
import '../../../ride_start/data/models/ridestart_data_model.dart';

abstract class ActiveRidesDriverRepository {
  Future<List<ActiveRideEntity>> getActiveRidesDriver();
  Future<void> cancelRide(String rideId);
  Future<RidestartDataModel> getRideData(String rideId, String token);
}
