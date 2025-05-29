import '../../../cars/domain/entity/car.dart';
import '../../domain/entity/ride_request.dart';

class RideRequestModel {
  final String driverId;
  final int numOfSeats;
  final CarEntity car;
  final List<dynamic> coords;
  final Map<String, dynamic> source;
  final Map<String, dynamic> destination;
  final preference_driver preference;
  final String departureTime;
  final String maxArrivalTime;
  final double distance;
  final int duration;
  final String date;
  final List<String> paymentMethod;
  final bool isRecurring;
  final String? frequency;
  final Set<String>? selectedDays;
  final DateTime? endDate;

  RideRequestModel({
    required this.driverId,
    required this.numOfSeats,
    required this.car,
    required this.coords,
    required this.source,
    required this.destination,
    required this.preference,
    required this.departureTime,
    required this.maxArrivalTime,
    required this.distance,
    required this.duration,
    required this.date,
    required this.paymentMethod,
    required this.isRecurring,
    this.frequency,
    this.selectedDays,
    this.endDate,
  });

  // Convert to JSON-serializable Map
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'numOfSeats': numOfSeats,
      "car": {
        "company": car.company,
        "model": car.model,
        "color": car.color,
        "number_plate": car.numberPlate,
        "mileage": car.mileage,
        "isVerified": car.isVerified,
        "carId": car.carId,
      },
      'source': source,
      'destination': destination,
      'preferences': {
        'maleOnly': preference.maleOnly,
        'femaleOnly': preference.femaleOnly,
      },
      'departureTime': departureTime,
      'maxArrivalTime': maxArrivalTime,
      'distance': distance,
      'duration': duration,
      'date': date,
      'paymentMethod': paymentMethod,
      'isRecurring': isRecurring,
      'frequency': frequency,
      // FIX: Convert Set to List for JSON serialization
      'customDays': (selectedDays?.isNotEmpty ?? false) ? selectedDays!.toList() : [],
      'endsOn': endDate?.toIso8601String(),
      'coords': coords,
    };
  }
}