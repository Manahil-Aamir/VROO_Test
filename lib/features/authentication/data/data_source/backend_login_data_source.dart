import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';

abstract class BackendLoginDataSource {
  Future<void> notifyLogin(String token);
}

class BackendLoginDataSourceImpl implements BackendLoginDataSource {
  final http.Client client;

  BackendLoginDataSourceImpl({required this.client});

  @override
  Future<void> notifyLogin(String token) async {
    print('in backend login data source');
    print('Logintoken: $token');
    final url = Uri.parse('${ApiConstants.baseUrl}users/login');
    // final url = Uri.parse('http://10.0.2.2:8080/users/login');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Backend notified');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to notify backend: ${response.body}');
    }
  }
}