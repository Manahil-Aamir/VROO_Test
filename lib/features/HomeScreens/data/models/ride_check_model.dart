import '../../domain/entity/ride_check_entity.dart';

class RideCheckModel extends RideCheckEntity {
  const RideCheckModel({
    required super.id,
    required super.driverId,
    required super.driverNameFromUser,
    required super.driverEmail,
  });

  factory RideCheckModel.fromJson(Map<String, dynamic> json) {
    return RideCheckModel(
      id: json['_id'] ?? '',
      driverId: json['driverId'] ?? '',
      driverNameFromUser: json['driverNameFromUser'] ?? '',
      driverEmail: json['driverEmail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverId': driverId,
      'driverNameFromUser': driverNameFromUser,
      'driverEmail': driverEmail,
    };
  }

  @override
  String toString() {
    return 'RideCheckModel(id: $id, driverId: $driverId, driverNameFromUser: $driverNameFromUser, driverEmail: $driverEmail)';
  }
}
