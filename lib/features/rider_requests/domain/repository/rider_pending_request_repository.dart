import '../entity/rider_pending_request_entity.dart';

abstract class RiderPendingRequestRepository {
  Future<List<RiderPendingRequest>> getPendingRequests();
}
