import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/chat_fcm_token_model.dart';


abstract class ChatRemoteDataSource {
  Future<List<ChatUserModel>> getChatUsers(String role, String token);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl(this.client);

  @override
  Future<List<ChatUserModel>> getChatUsers(String role, String token) async {
    print('Fetching chat users for role: ${role.toLowerCase()}');
    print('Token: $token');
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${role.toLowerCase()}/message-access'
        // 'http://10.0.2.2:8080/${role.toLowerCase()}/message-access'
      );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Adding the Bearer token
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> usersJson = data['data'];

      return usersJson.map((user) => ChatUserModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load chat users');
    }
  }
}
