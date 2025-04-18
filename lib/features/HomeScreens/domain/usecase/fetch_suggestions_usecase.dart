import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entity/prediction.dart';
import '../repository/location_repository.dart';

class FetchSuggestionsUseCase {
  final LocationRepository repository;

  FetchSuggestionsUseCase(this.repository);

  Future<List<Prediction>> execute(String input) {
    return repository.fetchSuggestions(input);
  }

  Future<String?> getPlaceId(double lat, double lng) {
    return repository.getPlaceId(lat, lng);
  }

  Future<LatLng> getLatLng(String placeId) {
    return repository.getLatLng(placeId);
  }
}
