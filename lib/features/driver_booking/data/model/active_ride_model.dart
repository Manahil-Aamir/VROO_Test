import '../../domain/entity/active_ride.dart';
import 'carr_model.dart';

class ActiveRideModel {
  final String id;
  final Car car;
  final DateTime date;
  final int fare;
  final LocationModel source;
  final LocationModel destination;
  final List<PassengerModel> passengers;
  final String status;

  ActiveRideModel({
    required this.id,
    required this.car,
    required this.date,
    required this.fare,
    required this.source,
    required this.destination,
    required this.passengers,
    required this.status,
  });

  factory ActiveRideModel.fromJson(Map<String, dynamic> json) {
  return ActiveRideModel(
    id: json['_id'] ?? '', // Handle null ID
    car: Car.fromJson(json['car'] ?? {}), // Handle null car

// String dateString = json['date'];  // Example: "2025-02-02T15:10:51.321000"
// DateTime date = DateTime.parse(dateString);

    date: DateTime.parse(json['date']),
    fare: json['fare']?.toInt() ?? 0,
    source: LocationModel.fromJson(json['source'] ?? {}),
    destination: LocationModel.fromJson(json['destination'] ?? {}),
    passengers: List<PassengerModel>.from(
      (json['passengers'] ?? []).map((x) => PassengerModel.fromJson(x))
    ),
    status: json['status'] ?? 'unknown', // Handle null status
  );
}

  ActiveRideEntity toEntity() => ActiveRideEntity(
        id: id,
        car: car.toEntity(),
        date: date,
        fare: fare,
        source: source.toEntity(),
        destination: destination.toEntity(),
        passengers: passengers.map((p) => p.toEntity()).toList(),
        status: status,
      );
}

class LocationModel {
  final String address;
  final String cellId;
  final List<double> coords;
  final String placeId;

  LocationModel({
    required this.address,
    required this.cellId,
    required this.coords,
    required this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
  return LocationModel(
    address: json['address'] ?? 'Unknown address',
    cellId: json['cellId'] ?? '',
    coords: List<double>.from((json['coords'] ?? []).map((x) => x.toDouble())),
    placeId: json['placeId'] ?? '',
  );
}

  LocationEntity toEntity() => LocationEntity(
        address: address,
        cellId: cellId,
        coords: coords,
        placeId: placeId,
      );
}

class PassengerModel {
  final int fare;
  final String rideRequestId;
  final String riderId;
  final String status;

  PassengerModel({
    required this.fare,
    required this.rideRequestId,
    required this.riderId,
    required this.status,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      fare: json['fare']?.toInt() ?? 0,
      rideRequestId: json['rideRequestId'] ?? '',
      riderId: json['riderId'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }

  PassengerEntity toEntity() => PassengerEntity(
        fare: fare,
        rideRequestId: rideRequestId,
        riderId: riderId,
        status: status,
      );
}