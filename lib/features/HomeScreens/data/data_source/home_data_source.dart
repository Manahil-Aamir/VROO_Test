import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vroo_test/features/HomeScreens/data/models/ongoing_model.dart';
import 'package:vroo_test/features/HomeScreens/data/models/review_check_model.dart';

import '../../../authentication/data/data_source/user_preference.dart';
import '../../../../core/utils/constant/api_constants.dart';
import '../../../authentication/data/model/user_model.dart';
import '../models/ride_check_model.dart';

abstract class HomeDataSource {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
  Future<UserModel?> getUser();
  Future<OngoingModel> ongoing(String token);
  Future<RideCheckModel?> rideCheck(String rideId, String token);
  Future<bool> giveReview(ReviewModel reviewRequest, String token);
}

class HomeDataSourceImpl implements HomeDataSource {
  final http.Client client;
  HomeDataSourceImpl(this.client);

  @override
  Future<LatLng> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    return const LatLng(24.8607, 67.0011);
  }

  @override
  Future<void> clearSharedPreferences() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Small delay
    print('Clearing SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();

    // Get all keys
    final allKeys = prefs.getKeys();

    // Remove all keys except the user data key
    for (final key in allKeys) {
      print('Key: $key');
      if (key != UserPreferences.userKey) {
        await prefs.remove(key);
      }
    }

    print('SharedPreferences cleared except for user data.');
    print('User data: ${prefs.getString(UserPreferences.userKey)}');
    print('All keys: ${prefs.getKeys()}');
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return UserModel.fromJson(json);
    }
    return null;
  }

  @override
  @override
  Future<OngoingModel> ongoing(String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}users/rides/ongoing');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await client.get(url, headers: headers);
      final jsonData = json.decode(response.body);
      jsonData.forEach((key, value) {
        if (value == null) {
          print('Null value found for key: $key');
        }
      });

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List && jsonData['data'].isNotEmpty) {
          final ongoingModel = OngoingModel.fromMap(jsonData['data'][0]);

          // Store ride ID in SharedPreferences when data is returned
          await _storeRideId(ongoingModel.rideId);

          return ongoingModel;
        } else {
          return OngoingModel(
            rideId: 'sample_id',
            mode: 'sample_status',
          );
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load ride data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load ride data: $e');
    }
  }

// Helper method to store ride ID in SharedPreferences
  Future<void> _storeRideId(String rideId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_ride_id', rideId);
      print('Ride ID stored in SharedPreferences: $rideId');
    } catch (e) {
      print('Error storing ride ID in SharedPreferences: $e');
    }
  }

  @override
  Future<RideCheckModel?> rideCheck(String rideId, String token) async {
    final url = Uri.parse('http://10.0.2.2:8080/ride/ride-check/$rideId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await client.get(url, headers: headers);
      final jsonData = json.decode(response.body);
      print('checkinggggggg');
      print(jsonData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Ride check response: ${response.body}');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return RideCheckModel.fromJson(jsonData['data']);
        } else {
          // If success is false or data is null
          print('Ride check failed or no data: ${jsonData['message']}');
          return null;
        }
      } else {
        print('Ride check error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to check ride: ${response.statusCode}');
      }
    } catch (e) {
      print('Ride check exception: $e');
      throw Exception('Failed to check ride: $e');
    }
  }

  @override
  Future<bool> giveReview(ReviewModel reviewRequest, String token) async {
    final url = Uri.parse('http://10.0.2.2:8080/rider/give-reviews');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await client.post(
        url,
        headers: headers,
        body: json.encode(reviewRequest.toJson()),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('Review response: ${response.body}');

        if (jsonData['success'] == true) {
          print('Review submitted successfully: ${jsonData['message']}');
          return true;
        } else {
          print('Review submission failed: ${jsonData['message']}');
          return false;
        }
      } else {
        print('Review error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to submit review: ${response.statusCode}');
      }
    } catch (e) {
      print('Review exception: $e');
      throw Exception('Failed to submit review: $e');
    }
  }
}
