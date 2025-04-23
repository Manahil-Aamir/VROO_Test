import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';

import '../../../../core/utils/constant/api_constants.dart';
import '../model/active_ride_model.dart';

abstract class ActiveRidesDriverDataSource {
  Future<List<ActiveRideModel>> getActiveRidesDriver(String token);
  Future<void> cancelRide(String rideId, String token);
  Future<RideStartModel> getRideData(String rideId, String token);
}

class ActiveRidesDriverRemoteDataSource implements ActiveRidesDriverDataSource {
  final http.Client client;

  ActiveRidesDriverRemoteDataSource(this.client);

  @override
  Future<List<ActiveRideModel>> getActiveRidesDriver(String token) async {
    // print('Driver ID: $driverId');
    print('Token: $token');
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}driver/active-rides'
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

  @override
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

  @override
  Future<RideStartModel> getRideData(String rideId, String token) async {
    final url = Uri.parse('http://localhost:8080/driver/ride/data//$rideId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RideStartModel.fromMap(jsonData['data']);
      } else {
        throw Exception('Failed to load ride data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ride data: $e');
    }
  }
}
