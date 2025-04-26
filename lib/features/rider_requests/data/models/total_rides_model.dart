import '../../domain/entity/total_rides_entity.dart';

class TotalRidesModel extends TotalRides {
  TotalRidesModel({
    required super.asDriver,
    required super.asRider,
  });

  factory TotalRidesModel.fromJson(Map<String, dynamic> json) {
    return TotalRidesModel(
      asDriver: json['asDriver'],
      asRider: json['asRider'],
    );
  }

  // toEntity()
  TotalRides toEntity() {
    return TotalRides(
      asDriver: asDriver,
      asRider: asRider,
    );
  }
}
