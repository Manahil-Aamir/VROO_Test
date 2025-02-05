import 'package:vroo_test/features/driver_booking/domain/entity/active_ride.dart';

abstract class ActiveRidesRepository {
  Future<List<ActiveRideEntity>> getActiveRides(String driverId);
}