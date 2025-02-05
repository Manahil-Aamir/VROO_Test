import '../entity/prediction.dart';
import '../repository/location_repository.dart';

class FetchSuggestionsUseCase {
  final LocationRepository repository;

  FetchSuggestionsUseCase(this.repository);

  Future<List<Prediction>> execute(String input) {
    return repository.fetchSuggestions(input);
  }
}
