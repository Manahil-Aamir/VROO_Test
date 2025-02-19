import '../../domain/entity/pending_rides.dart';
import '../../domain/repository/pending_rides_repository.dart';
import '../data_source/pending_rides_data_source.dart';

class PendingRidesRepositoryImpl implements PendingRidesRepository {
  final PendingRidesDataSource dataSource;

  PendingRidesRepositoryImpl(this.dataSource);

  @override
  Future<List<PendingRidesEntity>> getPendingRides(String rideId) async {
    final rides = await dataSource.getPendingRides(rideId);
    return rides.map<PendingRidesEntity>((model) => model.toEntity()).toList();
  }

  @override
  Future<void> approveRideRequest(String rideRequestId, String rideId) async {
    await dataSource.approveRideRequest(rideRequestId, rideId);
  }
}
