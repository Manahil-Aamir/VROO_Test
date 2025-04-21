import '../../domain/entity/ratings.dart';

class RatingsModel {
  final int asDriver;
  final int asRider;

  RatingsModel({
    required this.asDriver,
    required this.asRider,
  });

  factory RatingsModel.fromJson(Map<String, dynamic> json) {
    return RatingsModel(
      asDriver: json['asDriver']?.toInt() ?? 0, // Handle null and type conversion
      asRider: json['asRider']?.toInt() ?? 0,
    );
  }

  Ratings toEntity() => Ratings(
        asDriver: asDriver,
        asRider: asRider,
      );
}