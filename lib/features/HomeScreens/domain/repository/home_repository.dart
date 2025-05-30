import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../authentication/data/model/user_model.dart';
import '../../data/data_source/home_data_source.dart';
import '../../data/models/ongoing_model.dart';
import '../../data/models/review_check_model.dart';
import '../../data/models/ride_check_model.dart';

abstract class HomeRepository {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
  Future<UserModel?> getUser();
  Future<OngoingModel> ongoing(String token);
  Future<RideCheckModel?> rideCheck(String rideId, String token);
  Future<bool> giveReview(ReviewModel reviewRequest, String token);
}
