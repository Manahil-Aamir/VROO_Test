import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.reviewerRole,
    required super.uid,
    required super.star,
    super.review,
    required super.receiverUid,
    required super.rideId,
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.version,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> json) {
    return ReviewModel(
      reviewerRole: json['reviewerRole'] ?? '',
      uid: json['uid'] ?? '',
      star: json['star'] ?? 0,
      review: json['review'] ?? '',
      receiverUid: json['receiverUid'] ?? '',
      rideId: json['rideId'] ?? '',
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewerRole': reviewerRole,
      'uid': uid,
      'star': star,
      'review': review,
      'receiverUid': receiverUid,
      'rideId': rideId,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
