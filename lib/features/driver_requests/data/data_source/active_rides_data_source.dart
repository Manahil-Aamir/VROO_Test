import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/active_ride_model.dart';

abstract class ActiveRidesDataSource {
  Future<List<ActiveRideModel>> getActiveRides(String token);
  Future<void> cancelRide(String rideId, String token);
}

class ActiveRidesRemoteDataSource implements ActiveRidesDataSource {
  final http.Client client;

  ActiveRidesRemoteDataSource(this.client);

  @override
  Future<List<ActiveRideModel>> getActiveRides(String token) async {
    // print('Driver ID: $driverId');
    print('Token: $token');
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}driver/active-rides'
        // 'http://10.0.2.2:8080/driver/active-rides/$driverId'
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => ActiveRideModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load active rides');
  }

  Future<void> cancelRide(String rideId, String token) async {
    print('Cancelling ride with ID: $rideId');
    String url = '${ApiConstants.baseUrl}driver/cancel/$rideId';
    print('URL: $url');
    final response = await client.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel ride');
    }
  }
}
