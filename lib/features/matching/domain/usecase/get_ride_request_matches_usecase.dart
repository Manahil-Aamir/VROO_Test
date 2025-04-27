import '../../data/models/matching_rides_model.dart';
import '../repository/matching_repository.dart';

class GetRideRequestMatchesUseCase {
  final MatchingRepository repository;

  GetRideRequestMatchesUseCase(this.repository);

  Future<List<MatchingRideModel>> execute(String rideRequestId) {
    print('GetRideRequestMatchesUseCase executing for ID: $rideRequestId');
    return repository.getRideRequestMatches(rideRequestId);
  }
}