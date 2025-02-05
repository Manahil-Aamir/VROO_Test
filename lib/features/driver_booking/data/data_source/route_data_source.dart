import 'dart:convert';
import 'package:http/http.dart' as http;

class RouteDataSource {
  final http.Client client;

  RouteDataSource(this.client);

  Future<Map<String, dynamic>?> fetchRoutes(String fromPlaceId, String toPlaceId) async {
    final url = Uri.parse('https://vrooapp-a2fqgtc3cng6gca8.westindia-01.azurewebsites.net/driver/routeoptions');
    // final url = Uri.parse('http://10.0.2.2:5000/driver/routeoptions');
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
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch routes. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }
}
