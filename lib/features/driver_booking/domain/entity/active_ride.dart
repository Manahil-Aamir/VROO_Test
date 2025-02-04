import 'car.dart';

class ActiveRideEntity {
  final String id;
  final CarEntity car;
  final DateTime date;
  final int fare;
  final LocationEntity source;
  final LocationEntity destination;
  final List<PassengerEntity> passengers;
  final String status;

  ActiveRideEntity({
    required this.id,
    required this.car,
    required this.date,
    required this.fare,
    required this.source,
    required this.destination,
    required this.passengers,
    required this.status,
  });
}

class LocationEntity {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationEntity({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });
}

class PassengerEntity {
  final int fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  PassengerEntity({
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });
}
