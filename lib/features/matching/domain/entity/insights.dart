class ReviewEntity {
  final String id;
  final String reviewerRole;
  final int star;
  final String? review;
  final DateTime createdAt;
  final String reviewerName;

  ReviewEntity({
    required this.id,
    required this.reviewerRole,
    required this.star,
    this.review,
    required this.createdAt,
    required this.reviewerName,
  });
}

class InsightEntity {
  final String insights;
  final List<ReviewEntity> topReviews;

  InsightEntity({
    required this.insights,
    required this.topReviews,
  });
}
