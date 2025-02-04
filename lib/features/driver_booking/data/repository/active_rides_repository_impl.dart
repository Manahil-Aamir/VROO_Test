import 'package:vroo_test/features/driver_booking/domain/entity/active_ride.dart';
import '../../domain/repository/active_rides_repository.dart';
import '../data_source/active_rides_data_source.dart';

class ActiveRidesRepositoryImpl implements ActiveRidesRepository {
  final ActiveRidesDataSource dataSource;

  ActiveRidesRepositoryImpl(this.dataSource);

  @override
  Future<List<ActiveRideEntity>> getActiveRides(String driverId) async {
    final rides = await dataSource.getActiveRides(driverId);
    return rides.map((model) => model.toEntity()).toList();
  }
}