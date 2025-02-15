import 'package:http/http.dart' as http;
import 'package:vroo_test/features/sign_up/data/model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> createUser(UserModel profile);
}

class ApiUserRemoteDataSource implements UserRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'your_backend_url/users';

  ApiUserRemoteDataSource(this.client);

  @override
  Future<void> createUser(UserModel profile) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      body: profile.toJson(),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  }
}