import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../models/matching_rides_model.dart';

class MatchingDataSourceImpl {
  final http.Client client;
  final String apiKey = "AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI";

  MatchingDataSourceImpl({required this.client});

  Future<Map<String, dynamic>> sendJoinRequest(
      Map<String, String> rideData) async {
    print('matching data source');
    final url = Uri.parse('${ApiConstants.baseUrl}ride/ride-request/join'
        // 'http://10.0.2.2:8080/ride/ride-request/join'
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
      Uri.parse('${ApiConstants.baseUrl}rider/ride-request/$rideRequestId');

  final response = await client.patch(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);

    // Extract the 'data' field first
    final data = responseBody['data'];
    print('matching update');
    print(data);

    // Then extract 'matchingRides' from within 'data'
    if (data != null && data['matchingRides'] != null) {
      final matchingRides = data['matchingRides'];
      return matchingRides is List ? matchingRides : [];
    }
    
    // Fallback: if the structure is different, return empty list
    return [];
  } else {
    throw Exception("Failed to send ride request");
  }
}

  // In matching_data_source.dart
  Future<List<MatchingRideModel>> getRideRequestMatches(String rideRequestId, String token) async {
    print('Fetching ride request matches for ID: $rideRequestId');
    print('token: $token');
    final url = Uri.parse('${ApiConstants.baseUrl}rider/ride-request/$rideRequestId/matches');
    print(url);
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('url: $url');
    print('Response status for ride request matches: ${response.statusCode}');
    print('Response body for ride request matches: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data']['matches'];
      
      if (data is List) {
        List<MatchingRideModel> dataList = data.map((rideJson) => MatchingRideModel.fromJson(rideJson)).toList();
        print('successful map');
        print(dataList);
        return dataList;
      }
      throw Exception("Invalid data format - expected list of rides");
    } else {
      throw Exception("Failed to fetch ride request matches: ${response.statusCode}");
    }
  }
}
