import '../../data/repository/ridestart_repository_impl.dart';

class EndRide {
  final StartRideRepositoryImpl reviewRepository;

  EndRide(this.reviewRepository);

  Future<Map<String, dynamic>> call(String rideId, String token) async {
    print('Ending ride with ID: $rideId and token: $token');
    final endRideData = await reviewRepository.endRide(rideId, token);
    return endRideData;
  }
}
