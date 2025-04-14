import 'package:vroo_test/features/driver_requests/data/model/driver_rider_detail_model.dart';
import 'package:vroo_test/features/rider_requests/domain/entity/rider_approved_request_entity.dart';

import '../../../cars/data/model/carr_model.dart';
import '../../../driver_requests/data/model/location_modal.dart';
import '../../../driver_requests/data/model/ratings_modal.dart';
import '../../../driver_requests/domain/entity/driver_rider_detail.dart';

class RiderApprovedRequestModel extends RiderApprovedRequest {
  RiderApprovedRequestModel({
    required super.id,
    required super.driverId,
    required super.source,
    required super.destination,
    required super.date,
    required super.departureTime,
    required super.car,
    required super.passengers,
    required super.driver,
  });

  factory RiderApprovedRequestModel.fromJson(Map<String, dynamic> json) {
    return RiderApprovedRequestModel(
      id: json['_id'],
      driverId: json['driverId'],
      source: LocationModel.fromJson(json['source']).toEntity(),
      destination: LocationModel.fromJson(json['destination']).toEntity(),
      date: DateTime.parse(json['date']),
      departureTime: DateTime.parse(json['departureTime']),
      car: Car.fromJson(json['car']).toEntity(),
      passengers: List<DriverRiderDetail>.from(
        (json['passengerInfo'] ?? []).map((x) => DriverRiderDetailModel.fromJson(x).toEntity()),
      ),
      driver: DriverModel.fromJson(json['driver']).toEntity(),
    );
  }

  RiderApprovedRequest toEntity() {
    return RiderApprovedRequest(
      id: id,
      driverId: driverId,
      source: source,
      destination: destination,
      date: date,
      departureTime: departureTime,
      car: car,
      passengers: passengers,
      driver: driver,
    );
  }
}

class DriverModel extends DriverEntity {
  DriverModel({
    required super.name,
    required super.rating,
    required super.totalRides,
    required super.phoneNumber,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      name: json['name'],
      rating: RatingsModel.fromJson(json['rating']).toEntity(),
      totalRides: TotalRidesModel.fromJson(json['totalRides']).toEntity(),
      phoneNumber: json['phoneNumber'],
    );
  }

  DriverEntity toEntity() {
    return DriverEntity(
      name: name,
      rating: rating,
      totalRides: totalRides,
      phoneNumber: phoneNumber,
    );
  }
}

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
