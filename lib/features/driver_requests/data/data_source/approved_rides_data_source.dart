import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/approved_rides_model.dart';

abstract class ApprovedRidesDataSource {
  Future<List<ApprovedRidesModel>> getApprovedRides(String driverId, String token);
}

class ApprovedRidesRemoteDataSource implements ApprovedRidesDataSource {
  final http.Client client;

  ApprovedRidesRemoteDataSource(this.client);

  @override
  Future<List<ApprovedRidesModel>> getApprovedRides(String rideId, String token) async {
    try {
      print('Fetching approved ride details for ride ID: $rideId');
      final response = await client.get(
        Uri.parse(
          'http://10.0.2.2:8080/driver/approved-requests/$rideId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status approved rides: ${response.statusCode}');
      print('Response body for approved rides: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Print the full response for debugging
        print('Full API response: $jsonResponse');

        if (jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];

          // Print the first item to see its structure
          if (data.isNotEmpty) {
            print('First ride detail: ${data[0]}');
          }

          return data.map((json) => ApprovedRidesModel.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected data format: ${jsonResponse['data']}');
        }
      } else {
        throw Exception(
            'Failed to load ride details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ride details: $e');
      throw Exception('Failed to parse ride details');
    }
  }
}
