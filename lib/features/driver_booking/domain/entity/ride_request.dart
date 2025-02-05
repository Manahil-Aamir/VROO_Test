import 'car.dart';

class RideRequest {
  final String driverId;
  final int numOfSeats;
  final CarEntity car;
  final List<dynamic> coords;
  final Map<String, dynamic> source;
  final Map<String, dynamic> destination;
  final bool samegender;
  final String departureTime;
  final String maxArrivalTime;
  final double distance;
  final int duration;
  final String date;
  final double fare;
  final List<String> paymentMethod;

  RideRequest({
    required this.driverId,
    required this.numOfSeats,
    required this.car,
    required this.coords,
    required this.source,
    required this.destination,
    required this.samegender,
    required this.departureTime,
    required this.maxArrivalTime,
    required this.distance,
    required this.duration,
    required this.date,
    required this.fare,
    required this.paymentMethod,
  });
}
