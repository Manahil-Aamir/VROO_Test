import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';

abstract class StartRideRepository {
  Future<RidestartDataModel> startRide(String rideId, String token);
}
