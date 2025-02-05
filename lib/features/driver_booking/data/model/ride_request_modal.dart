import '../../domain/entity/car.dart';
import '../../domain/entity/ride_request.dart';

class RideRequestModel extends RideRequest {
  RideRequestModel({
    required String driverId,
    required int numOfSeats,
    required CarEntity car,
    required List<dynamic> coords,
    required Map<String, dynamic> source,
    required Map<String, dynamic> destination,
    required bool samegender,
    required String departureTime,
    required String maxArrivalTime,
    required double distance,
    required int duration,
    required String date,
    required double fare,
    required List<String> paymentMethod,
  }) : super(
          driverId: driverId,
          numOfSeats: numOfSeats,
          car: car,
          coords: coords,
          source: source,
          destination: destination,
          samegender: samegender,
          departureTime: departureTime,
          maxArrivalTime: maxArrivalTime,
          distance: distance,
          duration: duration,
          date: date,
          fare: fare,
          paymentMethod: paymentMethod,
        );

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
