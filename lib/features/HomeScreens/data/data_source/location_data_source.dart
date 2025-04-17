import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class LocationDataSource {
  final http.Client client;
  final String apiKey;

  LocationDataSource(this.client, {required this.apiKey});

  Future<List<PredictionModel>> fetchSuggestions(String input) async {
    final url = 
    // 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
    //           'input=$input&key=$apiKey&language=en&components=country:pk';
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
      'input=$input&key=$apiKey&language=en&components=country:pk'
      '&location=24.8607,67.0011&radius=30000';// 20 km around Karachi


    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['predictions'] as List)
          .map((json) => PredictionModel.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load suggestions');
  }

  Future<void> saveSelectedLocation({
    required PredictionModel prediction,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${role}_selected_location', jsonEncode({
      'description': prediction.description,
      'place_id': prediction.placeId,
    }));
  }

  Future<PredictionModel?> getSelectedLocation(String role) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${role}_selected_location');
    return jsonString != null 
        ? PredictionModel.fromJson(jsonDecode(jsonString))
        : null;
  }
}