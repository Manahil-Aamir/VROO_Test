import '../entity/prediction_entity.dart';

abstract class LocationRepository {
  Future<List<Location>> fetchSuggestions(String input);
  Future<void> saveSelectedLocation(Location prediction);
  Future<Location?> getSelectedLocation();
}
