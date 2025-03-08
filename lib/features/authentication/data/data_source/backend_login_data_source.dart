import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BackendLoginDataSource {
  Future<void> notifyLogin(String uid, String token);
}

class BackendLoginDataSourceImpl implements BackendLoginDataSource {
  final http.Client client;

  BackendLoginDataSourceImpl({required this.client});

  @override
  Future<void> notifyLogin(String uid, String token) async {
    print('in backend login data source');
    print('uid: $uid');
    final url = Uri.parse('http://10.0.2.2:8080/api/users/login');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'uid': uid}),
    );
    print(jsonEncode({'uid': uid}));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to notify backend: ${response.body}');
    }
  }
}