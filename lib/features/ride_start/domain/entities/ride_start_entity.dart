import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';

class RideStartEntity {
  final bool success;
  final String message;
  final RidestartDataModel data;

  RideStartEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
