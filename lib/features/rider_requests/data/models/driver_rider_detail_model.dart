import '../../domain/entity/driver_rider_detail.dart';
import '../../../../shared/data/models/ratings_modal.dart';

class DriverRiderDetailModel {
  final String name;
  final RatingsModel ratings;

  DriverRiderDetailModel({
    required this.name,
    required this.ratings,
  });

  factory DriverRiderDetailModel.fromJson(Map<String, dynamic> json) {
    return DriverRiderDetailModel(
      name: json['name'] ?? 'Unknown Rider',
      ratings: RatingsModel.fromJson(json['ratings'] ?? {}),
    );
  }

  DriverRiderDetail toEntity() => DriverRiderDetail(
        name: name,
        ratings: ratings.toEntity(),
      );
}