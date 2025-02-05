import '../entity/prediction.dart';

abstract class LocationRepository {
  Future<List<Prediction>> fetchSuggestions(String input);
  Future<void> saveSelectedLocation(Prediction prediction);
  Future<Prediction?> getSelectedLocation();
}
