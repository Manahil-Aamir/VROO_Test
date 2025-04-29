import '../repository/ride_request_join_repository.dart';

class CancelJoinRequestUsecase {
  final RideRequestJoinRepository repository;

  CancelJoinRequestUsecase(this.repository);

  Future<void> call(String joinRequestId) {
    return repository.cancelJoinRequest(joinRequestId);
  }
}