import 'package:vroo_test/features/ride_start/data/data_source/start_ride_datasource.dart';

import '../../domain/repository/ridestart_repository.dart';
import '../models/give_review_model.dart';
import '../models/review_model.dart';
import '../models/ridestart_data_model.dart';

class StartRideRepositoryImpl implements StartRideRepository {
  final StartRideDataSource dataSource;

  StartRideRepositoryImpl(this.dataSource);

  @override
  Future<RidestartDataModel> startRide(String rideId, String token) {
    final rideData = dataSource.startRide(rideId, token);
    return rideData;
  }

  @override
  Future<ReviewModel> giveReview(GiveReviewModel giveReview, String token) {
    final reviewData = dataSource.giveReview(giveReview, token);
    return reviewData;
  }

  @override
  Future<Map<String, dynamic>> pickPassenger(
      String rideId, String passengerId, String action, String token) {
    final pickPassengerData =
        dataSource.pickPassenger(rideId, passengerId, action, token);
    return pickPassengerData;
  }

  @override
  Future<Map<String, dynamic>> endRide(String rideId, String token) {
    final endRideData = dataSource.endRide(rideId, token);
    return endRideData;
  }
}
