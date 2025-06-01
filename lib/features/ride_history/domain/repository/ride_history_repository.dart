import '../entity/driver_history_entity.dart';
import '../entity/rider_history_entity.dart';

abstract class RideHistoryRepository {
  Future<DriverHistoryEntity> getDriverRideHistory();
  Future<RiderHistoryEntity> getRiderRideHistory();
}
