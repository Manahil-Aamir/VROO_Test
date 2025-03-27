import '../../domain/entity/car.dart';
import '../../domain/entity/ride_request.dart';

class RideRequestModel extends RideRequest {
  RideRequestModel({
    required super.driverId,
    required super.numOfSeats,
    required super.car,
    required super.coords,
    required super.source,
    required super.destination,
    required super.samegender,
    required super.departureTime,
    required super.maxArrivalTime,
    required super.distance,
    required super.duration,
    required super.date,
    required super.fare,
    required super.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId,
      "numOfSeats": numOfSeats,
      "car": {
        "company": car.company,
        "model": car.model,
        "color": car.color,
        "number_plate": car.numberPlate,
        "mileage": car.mileage,
        "isVerified": car.isVerified,
      },
      "coords": coords,
      "source": source,
      "destination": destination,
      "preferences": {
        "maleOnly": !samegender, // Inverse of femaleOnly
        "femaleOnly": samegender,
      },
      "departureTime": departureTime,
      "maxArrivalTime": maxArrivalTime,
      "distance": distance,
      "duration": duration,
      "date": date, // Date only
      "fare": fare,
      "paymentMethod": paymentMethod,
    };
  }
}
