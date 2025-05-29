import '../../../cars/domain/entity/car.dart';

class RideRequest {
  final String driverId;
  final int numOfSeats;
  final CarEntity car;
  final List<dynamic> coords;
  final Map<String, dynamic> source;
  final Map<String, dynamic> destination;
  final preference_driver preference;
  // final bool samegender;
  final String departureTime;
  final String maxArrivalTime;
  final double distance;
  final int duration;
  final String date;
  // final double fare;
  final List<String> paymentMethod;
  final bool isRecurring;
  final String? frequency;
  final Set<String>? selectedDays;
  final DateTime? endDate;


  RideRequest({
    required this.driverId,
    required this.numOfSeats,
    required this.car,
    required this.coords,
    required this.source,
    required this.destination,
    // required this.samegender,
    required this.preference,
    required this.departureTime,
    required this.maxArrivalTime,
    required this.distance,
    required this.duration,
    required this.date,
    // required this.fare,
    required this.paymentMethod,
    required this.isRecurring,
    this.frequency,
    this.selectedDays,
    this.endDate,
  });
}

class preference_driver {
  final bool maleOnly;
  final bool femaleOnly;

  preference_driver({required this.maleOnly, required this.femaleOnly});
}
