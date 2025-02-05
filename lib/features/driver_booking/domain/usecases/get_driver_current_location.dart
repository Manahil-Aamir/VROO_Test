import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/driver_home_repository.dart';

class GetDriverCurrentLocation {
  final DriverHomeRepository repository;

  GetDriverCurrentLocation(this.repository);

  Future<LatLng> execute() {
    return repository.getCurrentLocation();
  }
}
