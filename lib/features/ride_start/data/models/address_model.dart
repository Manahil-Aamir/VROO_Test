import 'package:vroo_test/features/ride_start/domain/entities/address_entity.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.address,
    required super.placeId,
    required super.coords,
    required super.cellId,
    super.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'placeId': placeId,
      'coords': coords,
      'cellId': cellId,
      'id': id,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] ?? '',
      placeId: json['placeId'] ?? '',
      coords: List<double>.from(json['coords'] ?? []),
      cellId: json['cellId'] ?? '',
      id: json['_id'],
    );
  }
}
