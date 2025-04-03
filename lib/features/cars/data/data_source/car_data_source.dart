import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/carr_model.dart';

abstract class CarRemoteDataSource {
  Future<List<Car>> fetchCarsFromApi(String token);
  Future<void> addCarToApi(Car car, String token);
  Future<void> deleteCarFromApi(String carId, String token);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final http.Client client;
  final String baseUrl = "http://10.0.2.2:8080/users/cars";

  CarRemoteDataSourceImpl(this.client);

  @override
  Future<List<Car>> fetchCarsFromApi(String token) async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      // Check if the response is successful
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        final List<dynamic> carsJson = decodedJson['data']['cars']; 
        return carsJson.map((car) => Car.fromJson(car)).toList();
      } else {
        throw Exception("Failed to load cars: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching cars: $e");
    }
  }

  @override
  Future<void> addCarToApi(Car car, String token) async {
    print("Adding car: ${car.toJson()}");
    print("Token: $token");
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(car.toJson()),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      if (response.statusCode != 201) {
        throw Exception("Failed to add car: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error adding car: $e");
    }
  }

  @override
  Future<void> deleteCarFromApi(String carId, String token) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/$carId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Delete response status: ${response.statusCode}");
      print("Delete response body: ${response.body}");
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete car: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting car: $e");
    }
  }

}
