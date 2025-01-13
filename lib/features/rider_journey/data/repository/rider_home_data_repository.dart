import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repository/rider_home_domain_repository.dart';
import '../data_source/rider_home_data_source.dart';

class RiderHomeRepositoryImpl implements RiderHomeRepository {
  final LocationDataSource dataSource;

  RiderHomeRepositoryImpl(this.dataSource);

  @override
  Future<LatLng> getCurrentLocation() {
    return dataSource.getCurrentLocation();
  }
}
