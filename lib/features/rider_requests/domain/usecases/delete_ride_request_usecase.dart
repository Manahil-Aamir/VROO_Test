import '../repository/rider_pending_request_repository.dart';

class DeleteRideRequestUseCase {
  final RiderPendingRequestRepository repository;

  DeleteRideRequestUseCase(this.repository);

  Future<void> execute(String requestId) async {
    return await repository.deleteRequest(requestId);
  }
}