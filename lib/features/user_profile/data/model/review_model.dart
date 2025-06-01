import '../../domain/entity/review.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.name,
    required super.comment,
    required super.rating,
    required super.daysAgo,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['reviewerName'] ?? '',
      comment: json['review'] ?? '',
      rating: (json['star'] ?? 0).toDouble(),
      daysAgo: (json['daysAgo'])
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'comment': comment,
        'rating': rating,
        'daysAgo': daysAgo,
      };
}

class RoleReviewSummaryModel extends RoleReviewSummaryEntity {
  RoleReviewSummaryModel({
    required super.oneStar,
    required super.twoStar,
    required super.threeStar,
    required super.fourStar,
    required super.fiveStar,
    required super.totalReviews,
    required super.allReviews,
  });

  factory RoleReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return RoleReviewSummaryModel(
      oneStar: json['1starrevs'] ?? 0,
      twoStar: json['2starrevs'] ?? 0,
      threeStar: json['3starrevs'] ?? 0,
      fourStar: json['4starrevs'] ?? 0,
      fiveStar: json['5starrevs'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      allReviews: (json['allrevs'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UserRatingsModel extends UserRatingsEntity {
  UserRatingsModel({
    required super.asDriver,
    required super.asRider,
  });

  factory UserRatingsModel.fromJson(Map<String, dynamic> json) {
    return UserRatingsModel(
      asDriver: (json['asDriver'] ?? 0).toDouble(),
      asRider: (json['asRider'] ?? 0).toDouble(),
    );
  }
}

class ReviewResponseModel extends ReviewResponseEntity {
  ReviewResponseModel({
    required super.receivedAsDriver,
    required super.receivedAsRider,
    required super.userRatings,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final reviews = data['reviews'] ?? {};

    return ReviewResponseModel(
      receivedAsDriver:
          RoleReviewSummaryModel.fromJson(reviews['receivedAsDriver'] ?? {}),
      receivedAsRider:
          RoleReviewSummaryModel.fromJson(reviews['receivedAsRider'] ?? {}),
      userRatings: UserRatingsModel.fromJson(data['userRatings'] ?? {}),
    );
  }
}
