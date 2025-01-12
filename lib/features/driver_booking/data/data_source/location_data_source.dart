import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_places_flutter/model/prediction.dart';

abstract class LocationDataSource {
  Future<List<Prediction>> fetchSuggestions(String input);
}

class LocationDataSourceImpl implements LocationDataSource {
  final http.Client client;

  LocationDataSourceImpl(this.client);

  @override
  Future<List<Prediction>> fetchSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI&language=en';

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['predictions'] as List)
          .map((json) => Prediction.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
