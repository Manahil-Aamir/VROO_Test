import '../entity/rider_approved_request_entity.dart';
import '../repository/rider_approved_request_repository.dart';

class GetApprovedRequestsUseCase {
  final RiderApprovedRequestRepository repository;

  GetApprovedRequestsUseCase(this.repository);

  Future<List<RiderApprovedRequest>> execute() async {
    return await repository.getApprovedRequests();
  }
}
