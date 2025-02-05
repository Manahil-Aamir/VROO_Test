import 'package:vroo_test/features/rider_journey/domain/entity/prediction_entity.dart';
import '../repository/location_repository.dart';

class FetchSuggestionsUseCase {
  final LocationRepository repository;

  FetchSuggestionsUseCase(this.repository);

  Future<List<Location>> execute(String input) {
    return repository.fetchSuggestions(input);
  }
}
