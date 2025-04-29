import 'package:vroo_test/features/ride_start/domain/repository/ridestart_repository.dart';

import '../../data/models/ridestart_data_model.dart';

class StartRide {
  final StartRideRepository repository;
  StartRide(this.repository);

  Future<RidestartDataModel> call(String rideId, String token) async {
    print('Starting ride with ID: $rideId and token: $token');
    final rideData = await repository.startRide(rideId, token);
    return rideData;
  }
}
