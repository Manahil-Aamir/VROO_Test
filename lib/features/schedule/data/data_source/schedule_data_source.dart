import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedules(String role, String token);
  Future<void> deleteSchedule(String id, String role, String token);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final http.Client client;

  ScheduleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ScheduleModel>> getSchedules(String role, String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}$role/scheduled-rides'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status $role requests: ${response.statusCode}');
    print('Response body for $role requests: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonList = jsonDecode(response.body)['data'];;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schedules: ${response.statusCode}');
    }
  }

   @override
  Future<void> deleteSchedule(String id, String role, String token) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}$role/scheduled-rides/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    
    print('Response status $role requests: ${response.statusCode}');
    print('Response body for $role requests: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete schedule: ${response.statusCode}');
    }
  }
}
