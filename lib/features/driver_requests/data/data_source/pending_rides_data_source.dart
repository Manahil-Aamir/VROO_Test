import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/pending_rides_model.dart';

abstract class PendingRidesDataSource {
  Future<List<PendingRidesModel>> getPendingRides(
      String driverId, String token);
  Future<void> approveRideRequest(
      String rideRequestId, String rideId, String token);
  Future<void> rejectRideRequest(
      String rideRequestId, String rideId, String token);
}

class PendingRidesRemoteDataSource implements PendingRidesDataSource {
  final http.Client client;

  PendingRidesRemoteDataSource(this.client);

  @override
  Future<List<PendingRidesModel>> getPendingRides(
      String rideId, String token) async {
    try {
      print('Fetching ride details for ride ID: $rideId');
      final response = await client.get(
        Uri.parse(
            // 'http://10.0.2.2:8080/driver/v2/ride-requests/$rideId',
            '${ApiConstants.baseUrl}driver/v2/ride-requests/$rideId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body for pending rides: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Print the full response for debugging
        print('Full API response: $jsonResponse');

        if (jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => PendingRidesModel.fromJson(json)).toList();
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

  @override
  Future<void> approveRideRequest(
      String rideRequestId, String rideId, String token) async {
    final url =
        // 'http://10.0.2.2:8080/ride/ride-request/join/$rideRequestId/approve'
        '${ApiConstants.baseUrl}ride/ride-request/join/$rideRequestId/approve';
    print(
        'datasource Approving ride request with ID: $rideRequestId for ride ID: $rideId');
    print(token);
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Approval response: ${response.body}');
    print('Approval status code: ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Approval failed: ${response.statusCode}');
    }
  }

  @override
  Future<void> rejectRideRequest(
      String rideRequestId, String rideId, String token) async {
    final url =
        // 'http://10.0.2.2:8080/ride/ride-request/join/$rideRequestId/reject'
        '${ApiConstants.baseUrl}ride/ride-request/join/$rideRequestId/reject';
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Rejection response: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Rejection failed: ${response.statusCode}');
    }
  }
}
