class RoleReviewSummaryEntity {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;
  final int totalReviews;
  final List<ReviewEntity> allReviews;

  RoleReviewSummaryEntity({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
    required this.totalReviews,
    required this.allReviews,
  });
}

class UserRatingsEntity {
  final double asDriver;
  final double asRider;

  UserRatingsEntity({
    required this.asDriver,
    required this.asRider,
  });
}

class ReviewResponseEntity {
  final RoleReviewSummaryEntity receivedAsDriver;
  final RoleReviewSummaryEntity receivedAsRider;
  final UserRatingsEntity userRatings;

  ReviewResponseEntity({
    required this.receivedAsDriver,
    required this.receivedAsRider,
    required this.userRatings,
  });
}

class ReviewEntity {
  final String name;
  final String comment;
  final double rating;
  final int daysAgo;

  ReviewEntity({
    required this.name,
    required this.comment,
    required this.rating,
    required this.daysAgo,
  });
}
