import 'dart:convert';
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
      print(data);
      return (data['predictions'] as List)
          .map((json) => PredictionModel.fromJson(json))
          .toList();
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to load suggestions');
    }
  }
}
