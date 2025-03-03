import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

abstract class UserRemoteDataSource {
  UserRemoteDataSource(http.Client client);

  Future<Map<String, dynamic>> createUser(UserModel user, String token);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> createUser(UserModel user, String token) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/signup');
    print('creating user');
    print(token);
    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );
      print(jsonEncode(user.toJson()));

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
