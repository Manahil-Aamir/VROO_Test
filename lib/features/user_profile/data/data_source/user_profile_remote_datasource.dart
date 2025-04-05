import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String token);
  Future<UserProfileModel> updateUserProfile(
      {String? name, String? phoneNumber, required String token});
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl = "http://10.0.2.2:3000/users/profile";

  UserProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<UserProfileModel> getUserProfile(String token) async {
    print('Token: $token');
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final userData = jsonData['data'];
      return UserProfileModel.fromJson(userData);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
      {String? name, String? phoneNumber, required String token}) async {
    print('[Profile] New name: $name');
    print('[Profile] New phone number: $phoneNumber');

    final response = await client.patch(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        if (name != null) 'name': name,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      }),
    );

    print('[Profile] Response status: ${response.statusCode}');
    print('[Profile] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final userData = jsonData['data'];
      return UserProfileModel.fromJson(userData);
    } else {
      throw Exception('Failed to update user profile');
    }
  }
}
