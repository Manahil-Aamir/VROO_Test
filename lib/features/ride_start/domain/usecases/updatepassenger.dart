import '../../data/repository/ridestart_repository_impl.dart';

class UpdatePassenger {
  final StartRideRepositoryImpl reviewRepository;

  UpdatePassenger(this.reviewRepository);

  Future<Map<String, dynamic>> call(
      String rideId, String passengerId, String action, String token) async {
    print(
        'Updating passenger with ID: $passengerId for ride: $rideId with action: $action');
    final pickPassengerData = await reviewRepository.pickPassenger(
        rideId, passengerId, action, token);
    return pickPassengerData;
  }
}
