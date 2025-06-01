import 'package:vroo_test/features/ride_start/domain/entities/give_review_entity.dart';

class GiveReviewModel extends GiveReviewEntity {
  GiveReviewModel({
    required super.uid,
    required super.star,
    super.review,
    required super.receiverUid,
    required super.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'star': star,
      'review': review,
      'receiverUid': receiverUid,
      'rideId': rideId,
    };
  }

  factory GiveReviewModel.fromMap(Map<String, dynamic> json) {
    return GiveReviewModel(
      uid: json['uid'] ?? '',
      star: json['star'] ?? 0,
      review: json['review'] ?? '',
      receiverUid: json['receiverUid'] ?? '',
      rideId: json['rideId'] ?? '',
    );
  }
}
