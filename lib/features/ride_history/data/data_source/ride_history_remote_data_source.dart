import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';
import '../models/driver_ride_history_model.dart';
import '../models/rider_ride_history_model.dart';

abstract class RideHistoryRemoteDataSource {
  Future<RideHistoryModel> getDriverRideHistory(String token);
  Future<RiderHistoryModel> getRiderRideHistory(String token);
}

class RideHistoryRemoteDataSourceImpl implements RideHistoryRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RideHistoryRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = '${ApiConstants.baseUrl}users/ride-history',
  });

  @override
  Future<RideHistoryModel> getDriverRideHistory(String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/driver'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('url: {$baseUrl}/driver');
      print("Response driver status: ${response.statusCode}");
      print("Response driver body: ${response.body}");
      
      if (response.statusCode == 200) {
        return RideHistoryModel.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception("Failed to load driver history: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting driver history: $e");
    }
  }

  @override
  Future<RiderHistoryModel> getRiderRideHistory(String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/rider'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('url: {$baseUrl}/rider');

      print("Response rider status: ${response.statusCode}");
      print("Response rider body: ${response.body}");
      
      if (response.statusCode == 200) {
        return RiderHistoryModel.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception("Failed to load rider history: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting rider history: $e");
    }
  }
}
