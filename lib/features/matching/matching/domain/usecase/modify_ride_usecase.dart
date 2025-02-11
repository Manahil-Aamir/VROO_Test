import 'package:vroo_test/features/rider_journey/data/model/ride_journey_model.dart';

import '../repository/matching_repository.dart';

class ModifyRideUseCase {
  final MatchingRepository repository;

  ModifyRideUseCase(this.repository);

  Future<List<dynamic>> execute(
      String rideRequestId, Map<String, dynamic> requestData) {
    return repository.requestRide(rideRequestId, requestData);
  }
}
