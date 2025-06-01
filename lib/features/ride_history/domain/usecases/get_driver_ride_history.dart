import '../entity/driver_history_entity.dart';
import '../repository/ride_history_repository.dart';

class GetDriverRideHistory {
  final RideHistoryRepository repository;

  GetDriverRideHistory(this.repository);

  Future<DriverHistoryEntity> call() async {
    return await repository.getDriverRideHistory();
  }
}
