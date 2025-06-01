import 'package:vroo_test/features/ride_start/data/repository/ridestart_repository_impl.dart';

import '../../data/models/give_review_model.dart';
import '../../data/models/review_model.dart';

class GiveReview {
  final StartRideRepositoryImpl reviewRepository;

  GiveReview(this.reviewRepository);

  Future<ReviewModel> call(GiveReviewModel giveReview, String token) async {
    print('Giving review with token: $token');
    final reviewData = await reviewRepository.giveReview(giveReview, token);
    return reviewData;
  }
}
