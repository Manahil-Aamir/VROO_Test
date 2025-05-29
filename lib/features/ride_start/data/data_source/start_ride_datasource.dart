import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../../../ride_start/data/models/ridestart_data_model.dart';
import '../models/give_review_model.dart';
import '../models/review_model.dart';

abstract class StartRideDataSource {
  Future<RidestartDataModel> startRide(String rideId, String token);
  Future<ReviewModel> giveReview(GiveReviewModel giveReview, String token);
  Future<Map<String, dynamic>> pickPassenger(
      String rideId, String passengerId, String action, String token);
  Future<Map<String, dynamic>> endRide(String rideId, String token);
}

class StartRideRemoteDataSource implements StartRideDataSource {
  final http.Client client;

  StartRideRemoteDataSource(this.client);

  @override
  Future<RidestartDataModel> startRide(String rideId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}driver/start-ride/$rideId');
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
        if (jsonData['data'] != null) {
          print('Ride data: ${jsonData['data']}');
          print('Data loaded successfully');
          return RidestartDataModel.fromMap(jsonData['data']);
        } else {
          print('Error: Data is null');
          throw Exception('Ride cannot be started without a passenger');
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load ride data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ride data: $e');
    }
  }

  @override
  Future<ReviewModel> giveReview(
      GiveReviewModel giveReview, String token) async {
    print('giveReview jhnklllllllllll: ${giveReview.toMap()}');

    final url = Uri.parse('http://10.0.2.2:8080/driver/give-review');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await client.post(url,
          headers: headers, body: json.encode(giveReview.toMap()));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return ReviewModel.fromMap(jsonData['data']);
        }
      }
      throw Exception('Failed to submit review: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error submitting review: ${e.toString()}');
    }
  }

  @override
  @override
  Future<Map<String, dynamic>> pickPassenger(
      String rideId, String passengerId, String action, String token) async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/driver/ride/$rideId/passenger/$passengerId?action=$action');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print(
        'Picking passenger - RideId: $rideId, PassengerId: $passengerId, Action: $action');

    try {
      final response = await client.get(url, headers: headers);
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('Passenger action completed successfully: $jsonData');
        return jsonData;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to perform passenger action: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to perform passenger action: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> endRide(String rideId, String token) async {
    final url = Uri.parse('http://10.0.2.2:8080/driver/end-ride/$rideId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print('Ending ride - RideId: $rideId');

    try {
      final response = await client.post(url, headers: headers);
      final jsonData = json.decode(response.body);
      print('Response data: $jsonData');
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Ride ended successfully: $jsonData');
        if (jsonData['success'] == true && jsonData['data'] != null) {
          print('Total CO₂ saved: ${jsonData['data']['totalCo2Saved']} kg');
          return jsonData;
        } else {
          print('Invalid response format: $jsonData');
          throw Exception('Invalid response format');
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to end ride: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to end ride: $e');
    }
  }
}
