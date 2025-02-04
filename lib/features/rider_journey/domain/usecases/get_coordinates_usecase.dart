import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/r3_repository.dart';

class GetCoordinatesUseCase {
  final R3Repository repository;

  GetCoordinatesUseCase(this.repository);

  Future<LatLng> call(String placeId) {
    return repository.getCoordinates(placeId);
  }
}
