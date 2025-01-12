import 'package:google_places_flutter/model/prediction.dart';

abstract class LocationRepository {
  Future<List<Prediction>> fetchSuggestions(String input);
}
