import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  // Future<void> updateUserProfile(String userId, UserProfileModel userProfile);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final http.Client client;

  UserProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    final response = await client.get(
      Uri.parse('http://10.0.2.2:8080/users/profile/$userId'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserProfileModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  // Future<void> updateUserProfile(String userId, UserProfileModel userProfile) async {
  //   final response = await client.put(
  //     Uri.parse('http://localhost:8080/users/profile/$userId'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(userProfile.toJson()),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update user profile');
  //   }
  // }

}
