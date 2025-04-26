import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vroo_test/core/utils/constant/api_constants.dart';

import '../model/user_model.dart';

abstract class BackendLoginDataSource {
  Future<UserModel> notifyLogin(String authToken, String fcmToken);
}

class BackendLoginDataSourceImpl implements BackendLoginDataSource {
  final http.Client client;

  BackendLoginDataSourceImpl({required this.client});

  @override
  Future<UserModel> notifyLogin(String authToken, String fcmToken) async {
    final url = Uri.parse('${ApiConstants.baseUrl}users/login');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcmToken': fcmToken}),
    );

    print('response statuscode: ${response.statusCode}');
    print('response body: ${response.body}');    

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return UserModel.fromJson(responseData['user']); // Extract only user part
    } else {
      final responseData = jsonDecode(response.body);
      // throw Exception('Failed to notify backend: ${response.body}');
      throw Exception('${responseData['message']}');
    }
  }
}

