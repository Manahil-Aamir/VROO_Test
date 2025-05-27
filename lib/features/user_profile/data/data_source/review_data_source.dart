import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/utils/constant/api_constants.dart';
import '../model/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewResponseModel> getReviews(String token);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSourceImpl({required this.client});

  @override
  Future<ReviewResponseModel> getReviews(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}users/reviews'),
      // Uri.parse('http://10.0.2.2:8080/users/reviews'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ReviewResponseModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load reviews: ${response.statusCode}');
    }
  }
}