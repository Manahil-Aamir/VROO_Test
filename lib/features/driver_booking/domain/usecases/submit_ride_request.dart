import '../entity/ride_request.dart';
import '../repository/ride_request_repository.dart';

class SubmitRideRequest {
  final RideRepository repository;

  SubmitRideRequest(this.repository);

  Future<void> call(RideRequest request) async {
    print('🔧 SubmitRideRequest: Use case called');
    print('🔧 SubmitRideRequest: Repository type: ${repository.runtimeType}');
    
    try {
      print('🔧 SubmitRideRequest: About to call repository.submitRideRequest');
      await repository.submitRideRequest(request);
      print('✅ SubmitRideRequest: Repository call successful');
    } catch (e, stackTrace) {
      print('❌ SubmitRideRequest: Repository call failed: $e');
      print('❌ SubmitRideRequest: Stack trace: $stackTrace');
      rethrow;
    }
  }
}
