import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';

class RouteDataSource {
  final http.Client client;

  RouteDataSource(this.client);

  Future<Map<String, dynamic>?> fetchRoutes(
    String fromPlaceId, String toPlaceId) async {
    print('from place id : $fromPlaceId');
    print('to place id : $toPlaceId');
    final url = Uri.parse(
      '${ApiConstants.baseUrl}driver/routeoptions'
      // 'http://10.0.2.2:8080/driver/routeoptions'
    );
    final body = jsonEncode({
      'source_place_id': fromPlaceId,
      'destination_place_id': toPlaceId,
    });

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch routes. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }
}
