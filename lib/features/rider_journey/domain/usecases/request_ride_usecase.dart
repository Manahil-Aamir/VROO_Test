import 'package:vroo_test/features/rider_journey/domain/repository/r3_repository.dart';

class RequestRideUseCase {
  final R3Repository repository;

  RequestRideUseCase(this.repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> requestData) {
    return repository.requestRide(requestData);
  }
}
