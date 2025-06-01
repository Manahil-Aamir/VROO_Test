import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';
import '../models/ride_request_join_model.dart';

abstract class RideRequestJoinRemoteDatasource {
  Future<List<RideRequestJoinModel>> getPendingRideRequestJoins(
      String token, String rideRequestId);
  Future<void> cancelJoinRequest(String token, String joinRequestId);
}

class RideRequestJoinRemoteDatasourceImpl
    implements RideRequestJoinRemoteDatasource {
  final http.Client client;

  RideRequestJoinRemoteDatasourceImpl(this.client);

  @override
  Future<List<RideRequestJoinModel>> getPendingRideRequestJoins(
      String token, String rideRequestId) async {
    print('token: $token');
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}rider/ride-request/pending/$rideRequestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status join requests: ${response.statusCode}');
    print('Response body for join requests: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'] ?? [];

      return data.map((json) => RideRequestJoinModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch pending ride requests: ${response.statusCode}');
    }
  }

  @override
  Future<void> cancelJoinRequest(String token, String joinRequestId) async {
    print('here in cancelJoinRequest');
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}rider/withdraw-request/$joinRequestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status for cancel join request: ${response.statusCode}');
    print('Response body for cancel join request: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel join request: ${response.statusCode}');
    }
  }
}
