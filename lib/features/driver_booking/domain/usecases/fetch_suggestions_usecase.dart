import 'package:google_places_flutter/model/prediction.dart';
import '../repository/location_repository.dart';

class FetchSuggestionsUseCase {
  final LocationRepository repository;

  FetchSuggestionsUseCase(this.repository);

  Future<List<Prediction>> call(String input) {
    return repository.fetchSuggestions(input);
  }
}
