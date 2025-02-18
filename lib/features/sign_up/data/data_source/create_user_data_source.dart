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
    final url = Uri.parse('http://localhost:3000/user2');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }
}
