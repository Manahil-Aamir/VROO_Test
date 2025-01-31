import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/prediction_model.dart';

class LocationDataSource {
  final http.Client client;
  final String apiKey;

  LocationDataSource(this.client, {required this.apiKey});

  Future<List<PredictionModel>> fetchSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=en';
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['predictions'] as List)
          .map((json) => PredictionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> saveSelectedLocation(PredictionModel prediction) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selected_location',
        jsonEncode({
          'description': prediction.description,
          'place_id': prediction.placeId,
        }));
  }

  Future<PredictionModel?> getSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('selected_location');
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString);
      return PredictionModel.fromJson(jsonData);
    }
    return null;
  }
}
