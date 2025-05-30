import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String receiverUid;
  final String rideId;
  final int star;
  final String review;

  const ReviewEntity({
    required this.receiverUid,
    required this.rideId,
    required this.star,
    required this.review,
  });

  @override
  List<Object?> get props => [receiverUid, rideId, star, review];

  @override
  String toString() {
    return 'ReviewEntity(receiverUid: $receiverUid, rideId: $rideId, star: $star, review: $review)';
  }
}
