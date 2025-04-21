import '../../domain/entity/location_entity.dart';

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
