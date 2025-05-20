class GiveReviewEntity {
  final String uid;
  final String receiverUid;
  final String rideId;
  final int star;
  final String? review;

  GiveReviewEntity({
    required this.uid,
    required this.receiverUid,
    required this.rideId,
    required this.star,
    this.review,
  });
}
