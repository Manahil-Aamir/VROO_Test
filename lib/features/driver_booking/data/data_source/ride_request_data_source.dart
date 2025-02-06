import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/ride_request_modal.dart';

abstract class RideRemoteDataSource {
  Future<void> submitRideRequest(RideRequestModel request);
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
  final http.Client client;

  RideRemoteDataSourceImpl(this.client);

  @override
  Future<void> submitRideRequest(RideRequestModel request) async {
    final url = Uri.parse(
        'https://vrooapp-a2fqgtc3cng6gca8.westindia-01.azurewebsites.net/driver/ride');
    final response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    print('Response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to submit ride request");
    }
  }
}
