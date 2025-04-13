import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/pending_rides.dart';
import '../../domain/repository/pending_rides_repository.dart';
import '../data_source/pending_rides_data_source.dart';

class PendingRidesRepositoryImpl implements PendingRidesRepository {
  final PendingRidesDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  PendingRidesRepositoryImpl(this.dataSource, this.firebaseAuth);

  // get user token after successful login
  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<List<PendingRidesEntity>> getPendingRides(String rideId) async {
    final rides = await dataSource.getPendingRides(rideId, await getUserToken());
    return rides.map<PendingRidesEntity>((model) => model.toEntity()).toList();
  }

  @override
  Future<void> approveRideRequest(String rideRequestId, String rideId) async {
    await dataSource.approveRideRequest(rideRequestId, rideId, await getUserToken());
  }

  @override
  Future<void> rejectRideRequest(String rideRequestId, String rideId) async {
    await dataSource.rejectRideRequest(rideRequestId, rideId, await getUserToken());
  }
}
