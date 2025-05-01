import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/ride_start/data/models/ride_start_model.dart';

import '../../../../core/utils/constant/api_constants.dart';
import '../../../ride_start/data/models/ridestart_data_model.dart';

abstract class StartRideDataSource {
  Future<RidestartDataModel> startRide(String rideId, String token);
}

class StartRideRemoteDataSource implements StartRideDataSource {
  final http.Client client;

  StartRideRemoteDataSource(this.client);

  @override
  Future<RidestartDataModel> startRide(String rideId, String token) async {
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
