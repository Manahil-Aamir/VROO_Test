import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';

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

  Future<RideResponseModel> sendRideRequest(
      Map<String, dynamic> requestData) async {
    final url = Uri.parse(
      // 'https://vrooapp-a2fqgtc3cng6gca8.westindia-01.azurewebsites.net/rider/ride-request'
      'http://10.0.2.2:8080/rider/ride-request'
    );
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    print('Response: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      print(responseBody);
      return RideResponseModel.fromMap(responseBody); // ✅ Convert map to model
    } else {
      throw Exception("Failed to send ride request");
    }
  }
}
