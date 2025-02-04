import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class R3DataSource {
  final http.Client client;
  final String apiKey = "AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI";

  R3DataSource({required this.client});

  Future<LatLng> fetchCoordinates(String placeId) async {
    final response = await client.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return LatLng(
        data['result']['geometry']['location']['lat'],
        data['result']['geometry']['location']['lng'],
      );
    } else {
      throw Exception("Failed to fetch coordinates");
    }
  }

  Future<Map<String, dynamic>> sendRideRequest(
      Map<String, dynamic> requestData) async {
    final url = Uri.parse('http://10.0.2.2:5000/rider/ride-request');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception("Failed to send ride request");
    }
  }
}
