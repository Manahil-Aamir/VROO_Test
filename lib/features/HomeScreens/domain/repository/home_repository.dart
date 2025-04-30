import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../authentication/data/model/user_model.dart';
import '../../data/models/ongoing_model.dart';

abstract class HomeRepository {
  Future<LatLng> getCurrentLocation();
  Future<void> clearSharedPreferences();
  Future<void> logout();
  Future<UserModel?> getUser();
  Future<OngoingModel> ongoing(String token);
}
