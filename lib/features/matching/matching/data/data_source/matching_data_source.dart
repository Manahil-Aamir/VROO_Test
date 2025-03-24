import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/constant/api_constants.dart';

class MatchingDataSource {
  final http.Client client;
  final String apiKey = "AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI";

  MatchingDataSource({required this.client});

  Future<Map<String, dynamic>> sendJoinRequest(
    Map<String, String> rideData) async {
    print('matching data source');
    final url = Uri.parse(
    //'${ApiConstants.baseUrl}ride/ride-request/join'
        'http://10.0.2.2:8080/ride/ride-request/join'
        );

    // Encode the data to JSON
    final String jsonBody = json.encode(rideData);
    print('jsonBody: $jsonBody');

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

  Future<List<dynamic>> sendRideRequest(
      String rideRequestId, Map<String, dynamic> requestData) async {
    final url =
        Uri.parse('http://10.0.2.2:8080/rider/ride-request/$rideRequestId');
        // Uri.parse('${ApiConstants.baseUrl}rider/ride-request/$rideRequestId');

    final response = await client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Extract only the 'data' field and ensure it's a List
      final data = responseBody['data'];
      print('matching update');
      print(data);

      return data is List ? data : [];
    } else {
      throw Exception("Failed to send ride request");
    }
  }
}
