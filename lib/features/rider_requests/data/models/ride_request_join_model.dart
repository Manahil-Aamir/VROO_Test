import '../../../../shared/data/models/location_modal.dart';
import '../../../../shared/data/models/ratings_modal.dart';
import '../../../cars/data/model/carr_model.dart';
import '../../domain/entity/ride_request_join.dart';


class RideRequestJoinModel {
  final String id;
  final RideModel ride;
  final RiderDetailsModel riderDetails;

  RideRequestJoinModel({
    required this.id,
    required this.ride,
    required this.riderDetails,
  });

  factory RideRequestJoinModel.fromJson(Map<String, dynamic> json) {
    return RideRequestJoinModel(
      id: json['_id'],
      ride: RideModel.fromJson(json['ride']),
      riderDetails: RiderDetailsModel.fromJson(json['riderDetails']),
    );
  }

  RideRequestJoinEntity toEntity() {
    return RideRequestJoinEntity(
      id: id,
      ride: ride.toEntity(),
      riderDetails: riderDetails.toEntity(),
    );
  }
}

class RideModel {
  final RatingsModel ratings;
  final LocationModel source;
  final LocationModel destination;
  final DateTime date;
  final DateTime departureTime;
  final String driverName;
  final int noOfSeats;
  final int noOfOccupiedSeats;
  final Car car;

  RideModel({
    required this.ratings,
    required this.source,
    required this.destination,
    required this.date,
    required this.departureTime,
    required this.driverName,
    required this.noOfSeats,
    required this.noOfOccupiedSeats,
    required this.car,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      ratings: RatingsModel.fromJson(json['driver']['ratings']),
      source: LocationModel.fromJson(json['source']),
      destination: LocationModel.fromJson(json['destination']),
      date: DateTime.parse(json['date']),
      departureTime: DateTime.parse(json['departureTime']),
      driverName: json['driverName'],
      noOfSeats: json['noOfSeats'],
      noOfOccupiedSeats: json['noOfOccupiedSeats'],
      car: Car.fromJson(json['car']),
    );
  }

  RideEntity toEntity() {
    return RideEntity(
      ratings: ratings.toEntity(),
      source: source.toEntity(),
      destination: destination.toEntity(),
      date: date,
      departureTime: departureTime,
      driverName: driverName,
      noOfSeats: noOfSeats,
      noOfOccupiedSeats: noOfOccupiedSeats,
      car: car.toEntity(),
    );
  }
}

class RiderDetailsModel {
  final double fare;
  final DateTime eta;

  RiderDetailsModel({
    required this.fare,
    required this.eta,
  });

  factory RiderDetailsModel.fromJson(Map<String, dynamic> json) {
    return RiderDetailsModel(
      fare: (json['fare'] as num).toDouble(),
      eta: DateTime.parse(json['eta']),
    );
  }

  RiderDetailsEntity toEntity() {
    return RiderDetailsEntity(
      fare: fare,
      eta: eta,
    );
  }
}

