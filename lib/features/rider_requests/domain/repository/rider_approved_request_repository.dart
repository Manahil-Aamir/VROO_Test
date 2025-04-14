import 'package:vroo_test/features/rider_requests/domain/entity/rider_approved_request_entity.dart';

abstract class RiderApprovedRequestRepository {
  Future<List<RiderApprovedRequest>> getApprovedRequests();
}