import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vroo_test/features/ride_start/data/models/rider_view_model.dart';

import '../../../../core/utils/constant/api_constants.dart';

abstract class RideViewDataSource {
  Future<RideViewModel> startRide(String rideId, String token);
}

class RideViewRemoteDataSource implements RideViewDataSource {
  final http.Client client;

  RideViewRemoteDataSource(this.client);

  @override
  Future<RideViewModel> startRide(String rideId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}driver/ride/data/$rideId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print('rideId: $rideId');

    try {
      final response = await client.get(url, headers: headers);
      print('response body: ${response.body}');
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        print('rideeeerrrrr dataa');

        print('data loaded');
        print(jsonData['data']);
        RideViewModel model = RideViewModel.fromMap(jsonData['data']);
        print('RideViewModel: ${model.carDetails}');

        return RideViewModel.fromMap(jsonData['data']);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load ride data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ride data: $e');
    }
  }
}
