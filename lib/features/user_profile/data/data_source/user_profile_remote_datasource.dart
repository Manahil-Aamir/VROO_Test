import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_profile_model.dart.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateUserProfile({String? name, String? phoneNumber, required String userId});
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

  Future<UserProfileModel> updateUserProfile({String? name, String? phoneNumber, required String userId}) async {
    print('[Profile] Updating user profile for userId: $userId');
    print('[Profile] New name: $name');
    print('[Profile] New phone number: $phoneNumber');
    final response = await client.patch(
      Uri.parse('http://10.0.2.2:8080/users/profile/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        if (name != null) 'name': name,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      }),
    );

    print('[Profile] Response status: ${response.statusCode}');
    print('[Profile] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserProfileModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to update user profile');
    }
  }

}
