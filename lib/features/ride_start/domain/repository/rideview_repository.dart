import 'package:vroo_test/features/ride_start/data/models/rider_view_model.dart';

abstract class RideViewRepository {
  Future<RideViewModel> startRide(String rideId, String token);
}
