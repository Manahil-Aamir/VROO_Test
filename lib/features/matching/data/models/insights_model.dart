import '../../domain/entity/insights.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required String id,
    required String reviewerRole,
    required int star,
    String? review,
    required DateTime createdAt,
    required String reviewerName,
  }) : super(
          id: id,
          reviewerRole: reviewerRole,
          star: star,
          review: review,
          createdAt: createdAt,
          reviewerName: reviewerName,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'],
      reviewerRole: json['reviewerRole'],
      star: json['star'],
      review: json['review'],
      createdAt: DateTime.parse(json['createdAt']),
      reviewerName: json['reviewerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reviewerRole': reviewerRole,
      'star': star,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
      'reviewerName': reviewerName,
    };
  }
}

class InsightModel extends InsightEntity {
  InsightModel({
    required String insights,
    required List<ReviewModel> topReviews,
  }) : super(
          insights: insights,
          topReviews: topReviews,
        );

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    var reviewsJson = json['topReviews'] as List<dynamic>;
    List<ReviewModel> reviews = reviewsJson
        .map((reviewJson) => ReviewModel.fromJson(reviewJson))
        .toList();

    return InsightModel(
      insights: json['insights'],
      topReviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insights': insights,
      'topReviews': topReviews.map((e) => (e as ReviewModel).toJson()).toList(),
    };
  }
}
