import '../../domain/entity/rides_details.dart';
import '../../domain/repository/rides_details_repository.dart';
import '../data_source/rides_details_data_source.dart';

class RideDetailsRepositoryImpl implements RideDetailsRepository {
  final RideDetailsDataSource dataSource;

  RideDetailsRepositoryImpl(this.dataSource);

  @override
  Future<List<RideDetailsEntity>> getRideDetails(String rideId) async {
    final rides = await dataSource.getRideDetails(rideId);
    return rides.map<RideDetailsEntity>((model) => model.toEntity()).toList();
  }

  @override
  Future<void> approveRideRequest(String rideRequestId, String rideId) async {
    await dataSource.approveRideRequest(rideRequestId, rideId);
  }
}
