import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';
import '../model/user_model.dart';

abstract class UserRemoteDataSource {
  UserRemoteDataSource(http.Client client);

  Future<Map<String, dynamic>> createUser(UserModel user, String token, String fcmToken);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> createUser(UserModel user, String token, String fcmToken) async {
    final url = Uri.parse('${ApiConstants.baseUrl}users/signup');
    // final url = Uri.parse('http://10.0.2.2:8080/users/signup');
    print('creating user');
    print('authtoken: $token');
    print('fcmToken: $fcmToken');
    final userJson = user.toJson();

    // Add the FCM token to the user JSON
    userJson['fcmToken'] = fcmToken;
    print('User JSON with FCM token: ${jsonEncode(userJson)}');

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(user.toJson()),
        body: jsonEncode(userJson),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;  // Re-throw the exception after logging it
    }
  }
}
