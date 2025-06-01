import 'package:vroo_test/features/HomeScreens/data/models/review_check_model.dart';

import '../../data/models/ride_check_model.dart';
import '../repository/home_repository.dart';

class ReviewUseCase {
  // This class can be used
  final HomeRepository repository;

  ReviewUseCase(this.repository);

  Future<bool> giveReview(ReviewModel reviewRequest, String token) async {
    return await repository.giveReview(reviewRequest, token);
  }

  Future<RideCheckModel?> rideCheck(String rideId, String token) async {
    return await repository.rideCheck(rideId, token);
  }
}
