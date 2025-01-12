import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repository/home_domain_repository.dart';
import '../data_source/home_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<LatLng> getCurrentLocation() {
    return dataSource.getCurrentLocation();
  }
}
