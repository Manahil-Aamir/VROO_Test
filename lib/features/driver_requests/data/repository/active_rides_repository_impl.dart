import 'package:firebase_auth/firebase_auth.dart';
import 'package:vroo_test/features/driver_requests/domain/entity/active_ride.dart';
import '../../../ride_start/data/models/ride_start_model.dart';
import '../../domain/repository/active_rides_repository.dart';
import '../data_source/active_rides_data_source.dart';

class ActiveRidesDriverRepositoryImpl implements ActiveRidesDriverRepository {
  final ActiveRidesDriverDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  ActiveRidesDriverRepositoryImpl(this.dataSource, this.firebaseAuth);

  // get user token after successful login
  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<List<ActiveRideEntity>> getActiveRidesDriver() async {
    final rides = await dataSource.getActiveRidesDriver(await getUserToken());
    return rides.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> cancelRide(String rideId) async {
    await dataSource.cancelRide(rideId, await getUserToken());
  }

  @override
  Future<RideStartModel> getRideData(String rideId, String token) async {
    final rideData = await dataSource.getRideData(rideId, token);
    return rideData;
  }
}
