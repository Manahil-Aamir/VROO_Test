import 'package:vroo_test/features/ride_start/data/data_source/start_ride_datasource.dart';
import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';

import '../../domain/repository/ridestart_repository.dart';
import '../models/ridestart_data_model.dart';

class StartRideRepositoryImpl implements StartRideRepository {
  final StartRideDataSource dataSource;

  StartRideRepositoryImpl(this.dataSource);

  @override
  Future<RidestartDataModel> startRide(String rideId, String token) {
    final rideData = dataSource.startRide(rideId, token);
    return rideData;
  }
}
