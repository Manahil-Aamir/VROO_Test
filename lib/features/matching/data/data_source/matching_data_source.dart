import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MatchingDataSource {
  final http.Client client;
  final String apiKey = "AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI";

  MatchingDataSource({required this.client});

  Future<Map<String, dynamic>> sendJoinRequest(
      Map<String, String> rideData) async {
    final url = Uri.parse('http://10.0.2.2:5000/rider/ride-request/join');

    // Encode the data to JSON
    final String jsonBody = json.encode(rideData);

    // Send the POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    // Check the response status
    if (response.statusCode == 201) {
      print('Data sent successfully');
      // Handle the response as needed
      return jsonDecode(response.body);
    } else {
      print('Failed to send data: ${response.statusCode}');
      // Handle the error as needed
      throw Exception('Failed to send join request');
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
