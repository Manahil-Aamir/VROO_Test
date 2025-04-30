import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vroo_test/features/HomeScreens/data/models/ongoing_model.dart';

import '../../../../core/utils/constant/api_constants.dart';
import '../../../authentication/data/model/user_model.dart';

abstract class HomeDataSource {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
  Future<UserModel?> getUser();
  Future<OngoingModel> ongoing(String token);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
          return OngoingModel.fromMap(jsonData['data'][0]);
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
}
