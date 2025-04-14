import '../../domain/entity/rider_pending_request_entity.dart';
import '../repository/rider_pending_request_repository.dart';

class GetPendingRequestsUseCase {
  final RiderPendingRequestRepository repository;

  GetPendingRequestsUseCase(this.repository);

  Future<List<RiderPendingRequest>> execute() async {
    return await repository.getPendingRequests();
  }
}