import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/pending_rides_model.dart';

abstract class PendingRidesDataSource {
  Future<List<PendingRidesModel>> getPendingRides(String driverId);
  Future<void> approveRideRequest(String rideRequestId, String rideId);
}

class PendingRidesRemoteDataSource implements PendingRidesDataSource {
  final http.Client client;

  PendingRidesRemoteDataSource(this.client);

  @override
  Future<List<PendingRidesModel>> getPendingRides(String rideId) async {
    try {
      print('Fetching ride details for ride ID: $rideId');
      final response = await client.get(
        // Uri.parse('http://10.0.2.2:5000/driver/active-rides/$driverId'),
        Uri.parse(
            'https://vrooapp-a2fqgtc3cng6gca8.westindia-01.azurewebsites.net/driver/ride-requests/$rideId'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
  Future<void> approveRideRequest(String rideRequestId, String rideId) async {
    final url =
        'https://vrooapp-a2fqgtc3cng6gca8.westindia-01.azurewebsites.net/rider/ride-request/join/$rideRequestId/approve';
    final response = await client.post(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Approval failed: ${response.statusCode}');
    }
  }
}
