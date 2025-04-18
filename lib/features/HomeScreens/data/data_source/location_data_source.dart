import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    await prefs.setString(
        '${role}_selected_location',
        jsonEncode({
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

  Future<String?> getPlaceId(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      if (results.isNotEmpty) {
        return results.first['place_id'];
      }
    }
    throw Exception('Failed to fetch place_id from lat/lng');
  }

  Future<LatLng> getPlacePosition(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        print('location: $location');
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('Failed to fetch location');
      }
    } catch (e) {
      print('Error fetching lat/lng from placeId: $e');
      return const LatLng(0, 0);
    }
  }
}
