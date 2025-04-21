import '../../domain/entity/approved_rides.dart';
import 'ratings_modal.dart';
import 'time_range_model.dart';

class ApprovedRidesWrapperModel {
  final int numOfSeats;
  final int passengersLength;
  final List<ApprovedRidesModel> passengers;

  ApprovedRidesWrapperModel({
    required this.numOfSeats,
    required this.passengersLength,
    required this.passengers,
  });

  factory ApprovedRidesWrapperModel.fromJson(Map<String, dynamic> json) {
    return ApprovedRidesWrapperModel(
      numOfSeats: json['numOfSeats'] ?? 0,
      passengersLength: json['passengersLength'] ?? 0,
      passengers: (json['passengers'] as List<dynamic>?)
              ?.map((p) => ApprovedRidesModel.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class ApprovedRidesModel {
  final String riderId;
  final String riderName;
  final String phoneNumber; 
  final String status;
  final int fare;
  final String rideRequestId;
  final String source;
  final String destination;
  final DateTime date;
  final TimeRangeModel pickupTimeRange;
  final DateTime maxArrivalTime;
  final RatingsModel ratings; 
  final String fcmToken;

  ApprovedRidesModel({
    required this.riderId,
    required this.riderName,
    required this.phoneNumber,
    required this.status,
    required this.fare,
    required this.rideRequestId,
    required this.source,
    required this.destination,
    required this.date,
    required this.pickupTimeRange,
    required this.maxArrivalTime,
    required this.ratings,
    required this.fcmToken, 
  });

  factory ApprovedRidesModel.fromJson(Map<String, dynamic> json) {
    return ApprovedRidesModel(
      riderId: json['riderId'] ?? '',
      riderName: json['riderName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      fare: json['fare']?.toInt() ?? 0,
      rideRequestId: json['rideRequestId'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      date: DateTime.parse(json['date']),
      pickupTimeRange: TimeRangeModel.fromJson(json['pickupTimeRange'] ?? {}),
      maxArrivalTime: DateTime.parse(json['maxArrivalTime']),
      ratings: RatingsModel.fromJson(json['ratings'] ?? {}), 
      fcmToken: json['fcmToken'] ?? '',
    );
  }

  ApprovedRidesEntity toEntity() {
    return ApprovedRidesEntity(
      riderId: riderId,
      riderName: riderName,
      phoneNumber: phoneNumber,
      status: status,
      fare: fare,
      rideRequestId: rideRequestId,
      source: source,
      destination: destination,
      date: date,
      pickupTimeRange: pickupTimeRange.toEntity(),
      maxArrivalTime: maxArrivalTime,
      ratings: ratings.toEntity(),
      fcmToken: fcmToken, 
    );
  }
}
