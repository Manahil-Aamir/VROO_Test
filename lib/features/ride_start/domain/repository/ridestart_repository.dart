import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';

import '../../data/models/give_review_model.dart';
import '../../data/models/review_model.dart';

abstract class StartRideRepository {
  Future<RidestartDataModel> startRide(String rideId, String token);
  Future<ReviewModel> giveReview(GiveReviewModel giveReview, String token);
}
