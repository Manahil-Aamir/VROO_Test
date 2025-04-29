// lib/data/datasource/rider_pending_request_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';
import '../models/rider_pending_request.dart';

abstract class RiderPendingRequestDataSource {
  Future<List<RiderPendingRequestModel>> getPendingRequests(String token);
  Future<void> deleteRequest(String requestId, String token);
}

class RiderPendingRequestDataSourceImpl implements RiderPendingRequestDataSource {
  final http.Client client;
  final String baseUrl;

  RiderPendingRequestDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConstants.baseUrl,
  });

  @override
  Future<List<RiderPendingRequestModel>> getPendingRequests(String token) async {
    print('Fetching pending requests for rider with token: $token');
    final response = await client.get(
      Uri.parse('${baseUrl}rider/ride-request/pending'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status pending requests: ${response.statusCode}');
    print('Response body for pending requests: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final List<dynamic> data = jsonData['data'];
        return data
            .map((requestJson) => RiderPendingRequestModel.fromJson(requestJson))
            .toList();
      } else {
        throw Exception('Failed to load pending requests: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load pending requests with status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteRequest(String requestId, String token) async {
    print('Deleting request with ID: $requestId');
    final response = await client.post(
      Uri.parse('${baseUrl}rider/delete-request/$requestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status for delete request: ${response.statusCode}');
    print('Response body for delete request: ${response.body}');

    if (response.statusCode != 200) {
      final jsonData = json.decode(response.body);
      throw Exception('Failed to delete request: ${jsonData['message'] ?? 'Unknown error'}');
    }
  }
}
