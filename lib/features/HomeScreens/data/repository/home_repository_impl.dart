import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../authentication/data/model/user_model.dart';
import '../data_source/home_data_source.dart';
import '../../domain/repository/home_repository.dart';
import '../models/ongoing_model.dart';
import '../models/review_check_model.dart';
import '../models/ride_check_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<LatLng> getCurrentLocation() => dataSource.getCurrentLocation();

  @override
  Future<void> clearSharedPreferences() => dataSource.clearSharedPreferences();

  @override
  Future<void> logout() => dataSource.logout();

  @override
  Future<UserModel?> getUser() {
    return dataSource.getUser();
  }

  @override
  Future<OngoingModel> ongoing(String token) async {
    return await dataSource.ongoing(token);
  }

  @override
  Future<RideCheckModel?> rideCheck(String rideId) async {
    return await dataSource.rideCheck(rideId);
  }

  @override

  /// [ReviewRequest] object as the request body.
  ///
  /// Returns a boolean indicating whether the submission was successful.
  Future<bool> giveReview(ReviewModel reviewRequest) async {
    return await dataSource.giveReview(reviewRequest);
  }
}
