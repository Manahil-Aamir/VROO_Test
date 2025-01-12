import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repository/driver_home_repository.dart';
import '../data_source/driver_home_data_source.dart';

class DriverLocationRepositoryImpl implements DriverLocationRepository {
  final DriverHomeDataSource dataSource;

  DriverLocationRepositoryImpl(this.dataSource);

  @override
  Future<LatLng> getCurrentLocation() {
    return dataSource.getCurrentLocation();
  }
}
