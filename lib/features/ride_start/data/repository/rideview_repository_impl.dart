import 'package:vroo_test/features/ride_start/data/data_source/rider_view_datasource.dart';
import 'package:vroo_test/features/ride_start/data/models/rider_view_model.dart';
import 'package:vroo_test/features/ride_start/domain/repository/rideview_repository.dart';

class RideViewRepositoryImpl implements RideViewRepository {
  final RideViewDataSource dataSource;

  RideViewRepositoryImpl(this.dataSource);

  @override
  Future<RideViewModel> startRide(String rideId, String token) {
    final rideData = dataSource.startRide(rideId, token);
    return rideData;
  }
}
