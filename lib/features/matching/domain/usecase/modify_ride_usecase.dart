import '../repository/matching_repository.dart';

class ModifyRideUseCase {
  final MatchingRepository repository;

  ModifyRideUseCase(this.repository);

  Future<Map<String, dynamic>> execute(Map<String, dynamic> requestData) {
    return repository.requestRide(requestData);
  }
}
