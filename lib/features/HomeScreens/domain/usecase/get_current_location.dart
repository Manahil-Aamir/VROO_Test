import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repository/home_repository.dart';

class GetCurrentLocation {
  final HomeRepository repository;

  GetCurrentLocation(this.repository);

  Future<LatLng> execute() => repository.getCurrentLocation();
}