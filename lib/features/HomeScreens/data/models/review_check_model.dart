import '../../domain/entity/review_check_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.receiverUid,
    required super.rideId,
    required super.star,
    required super.review,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      receiverUid: json['receiverUid'] ?? '',
      rideId: json['rideId'] ?? '',
      star: json['star'] ?? 0,
      review: json['review'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverUid': receiverUid,
      'rideId': rideId,
      'star': star,
      'review': review,
    };
  }

  @override
  String toString() {
    return 'ReviewCheckModel(receiverUid: $receiverUid, rideId: $rideId, star: $star, review: $review)';
  }
}
