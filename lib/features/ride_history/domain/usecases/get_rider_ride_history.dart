import '../entity/rider_history_entity.dart';
import '../repository/ride_history_repository.dart';

class GetRiderRideHistory {
  final RideHistoryRepository repository;

  GetRiderRideHistory(this.repository);

  Future<RiderHistoryEntity> call() async {
    return await repository.getRiderRideHistory();
  }
}