// In your data source file
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constant/api_constants.dart';

abstract class DriverInsightsDataSource {
  Future<String> fetchDriverInsights(String driverId, String token);
}

class DriverInsightsDataSourceImpl implements DriverInsightsDataSource {
  final http.Client client;

  DriverInsightsDataSourceImpl({required this.client});

  @override
  Future<String> fetchDriverInsights(String driverId, String token) async {
    try {
      print('Fetching driver insights for ID: $driverId'); 
      
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}driver/driver-insights/$driverId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['data']; // Just return the data field
      } else {
        throw Exception('Failed to load driver insights: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in fetchDriverInsights: $e'); 
      rethrow;
    }
  }
}

