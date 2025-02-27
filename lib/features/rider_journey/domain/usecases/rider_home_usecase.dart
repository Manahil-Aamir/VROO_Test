import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/rider_home_repository.dart';

class GetCurrentLocation {
  final RiderHomeRepository repository;

  GetCurrentLocation(this.repository);

  Future<LatLng> execute() {
    return repository.getCurrentLocation();
  }

  Future<void> logout() {
    return repository.logout();
  }
}
