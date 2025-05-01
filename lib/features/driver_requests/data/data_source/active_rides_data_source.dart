import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../../../ride_start/data/models/ridestart_data_model.dart';
import '../model/active_ride_model.dart';

abstract class ActiveRidesDriverDataSource {
  Future<List<ActiveRideModel>> getActiveRidesDriver(String token);
  Future<void> cancelRide(String rideId, String token);
  Future<RidestartDataModel> getRideData(String rideId, String token);
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
  Future<RidestartDataModel> getRideData(String rideId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}driver/ride/data/$rideId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print('rideId: $rideId');

    try {
      final response = await client.get(url, headers: headers);
      final jsonData = json.decode(response.body);
      jsonData.forEach((key, value) {
        if (value == null) {
          print('Null value found for key: $key');
        }
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print('Ride data: $jsonData');
        print('rideeeerrrrr dataa');

        print('data loaded');

        return RidestartDataModel.fromMap(jsonData['data']);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load ride data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ride data: $e');
    }
  }
}
