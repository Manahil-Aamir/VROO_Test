// review_entity.dart
class ReviewEntity {
  final String reviewerRole;
  final String uid;
  final int star;
  final String? review;
  final String receiverUid;
  final String rideId;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  ReviewEntity({
    required this.reviewerRole,
    required this.uid,
    required this.star,
    this.review,
    required this.receiverUid,
    required this.rideId,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
}
