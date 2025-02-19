import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/r3_repository.dart';

class RequestRideUseCase {
  final R3Repository repository;

  RequestRideUseCase(this.repository);

  Future<RideResponseModel> call(Map<String, dynamic> requestData) {
    return repository.requestRide(requestData);
  }
}
