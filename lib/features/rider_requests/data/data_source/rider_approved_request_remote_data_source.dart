import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';
import '../models/rider_approved_request_model.dart';

abstract class RiderApprovedRequestDataSource {
  Future<List<RiderApprovedRequestModel>> getApprovedRequests(String token);
}

class RiderApprovedRequestDataSourceImpl implements RiderApprovedRequestDataSource {
  final http.Client client;
  final String baseUrl;

  RiderApprovedRequestDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConstants.baseUrl,
  });

  @override
  Future<List<RiderApprovedRequestModel>> getApprovedRequests(String token) async {
    print('Fetching approved requests for rider with token: $token');
    print('URL: ${baseUrl}rider/ride-request/approved');
    final response = await client.get(
      Uri.parse('${baseUrl}rider/ride-request/approved'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status approved requests: ${response.statusCode}');
    print('Response body for approved requests: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final List<dynamic> data = jsonData['data'];
        return data
            .map((requestJson) => RiderApprovedRequestModel.fromJson(requestJson))
            .toList();
      } else {
        throw Exception('Failed to load approved requests: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load approved requests with status: ${response.statusCode}');
    }
  }
}
