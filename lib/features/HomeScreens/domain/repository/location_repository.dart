import '../entity/prediction.dart';

abstract class LocationRepository {
  Future<List<Prediction>> fetchSuggestions(String input);
  Future<void> saveSelectedLocation(Prediction prediction, String role);
  Future<Prediction?> getSelectedLocation(String role);
  Future<String?> getPlaceId(double lat, double lng);
}
