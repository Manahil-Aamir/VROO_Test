import '../../domain/entity/approved_rides.dart';
import '../../domain/repository/approved_rides_repository.dart';
import '../data_source/approved_rides_data_source.dart';

class ApprovedRidesRepositoryImpl implements ApprovedRidesRepository {
  final ApprovedRidesDataSource dataSource;

  ApprovedRidesRepositoryImpl(this.dataSource);

  @override
  Future<List<ApprovedRidesEntity>> getApprovedRides(String rideId) async {
    final rides = await dataSource.getApprovedRides(rideId);
    return rides.map<ApprovedRidesEntity>((model) => model.toEntity()).toList();
  }
}
