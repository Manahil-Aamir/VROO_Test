import '../entity/review.dart';

abstract class ReviewRepository {
  Future<ReviewResponseEntity> getReviews();
}