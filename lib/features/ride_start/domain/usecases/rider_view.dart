import 'package:vroo_test/features/ride_start/domain/repository/rideview_repository.dart';

import '../../data/models/rider_view_model.dart';

class RiderViewUseCase {
  final RideViewRepository repository;
  RiderViewUseCase(this.repository);

  Future<RideViewModel> call(String rideId, String token) async {
    print('Starting ride with ID: $rideId and token: $token');
    final rideData = await repository.startRide(rideId, token);
    return rideData;
  }
}
