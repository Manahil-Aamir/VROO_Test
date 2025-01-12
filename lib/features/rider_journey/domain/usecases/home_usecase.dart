import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/home_domain_repository.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<LatLng> execute() {
    return repository.getCurrentLocation();
  }
}
