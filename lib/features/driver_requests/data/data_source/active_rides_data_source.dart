import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/active_ride_model.dart';

abstract class ActiveRidesDataSource {
  Future<List<ActiveRideModel>> getActiveRides(String driverId);
}

class ActiveRidesRemoteDataSource implements ActiveRidesDataSource {
  final http.Client client;

  ActiveRidesRemoteDataSource(this.client);

  @override
  Future<List<ActiveRideModel>> getActiveRides(String driverId) async {
    final response = await client.get(
      Uri.parse('http://10.0.2.2:5000/driver/active-rides/$driverId'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => ActiveRideModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load active rides');
  }
}
