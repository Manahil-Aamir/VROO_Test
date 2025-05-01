import 'package:vroo_test/features/ride_start/data/models/address_model.dart';
import 'package:vroo_test/features/ride_start/data/models/inride_passenger_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';

class RidestartDataEntity {
  final String id;
  final String driverId;
  final double numOfSeats;
  final DateTime date;
  final AddressModel source;
  final AddressModel destination;
  final DateTime departureTime;
  final DateTime maxArrivalTime;
  final double distance;
  final double duration;
  final RidePreferencesModel preferences;
  final bool isRecurring;
  final CarDetailsModel car;
  final List<dynamic> recurringRides; // Adjust type if needed
  final List<String> paymentMethod;
  final double fare;
  final String status;
  final EnvironmentStatsModel environmentStats;
  final DateTime expectedArrivalTime;
  final List<List<double>> routeCoords;
  final List<InridePassengerModel> passengers;

  RidestartDataEntity({
    required this.id,
    required this.driverId,
    required this.numOfSeats,
    required this.date,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.maxArrivalTime,
    required this.distance,
    required this.duration,
    required this.preferences,
    required this.isRecurring,
    required this.car,
    required this.recurringRides,
    required this.paymentMethod,
    required this.fare,
    required this.status,
    required this.environmentStats,
    required this.expectedArrivalTime,
    required this.routeCoords,
    required this.passengers,
  });
}
