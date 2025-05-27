import 'package:vroo_test/features/user_profile/domain/entity/review.dart';

import '../repository/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase({required this.repository});

  Future<ReviewResponseEntity> call() async {
    return await repository.getReviews();
  }
}