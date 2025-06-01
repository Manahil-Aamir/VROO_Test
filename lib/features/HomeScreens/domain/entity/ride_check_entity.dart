import 'package:equatable/equatable.dart';

class RideCheckEntity extends Equatable {
  final String id;
  final String driverId;
  final String driverNameFromUser;
  final String driverEmail;

  const RideCheckEntity({
    required this.id,
    required this.driverId,
    required this.driverNameFromUser,
    required this.driverEmail,
  });

  @override
  List<Object?> get props => [id, driverId, driverNameFromUser, driverEmail];

  @override
  String toString() {
    return 'RideCheckEntity(id: $id, driverId: $driverId, driverNameFromUser: $driverNameFromUser, driverEmail: $driverEmail)';
  }
}
