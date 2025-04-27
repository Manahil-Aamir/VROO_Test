import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/matching_repository.dart';
import '../data_source/matching_data_source.dart';
import '../models/matching_rides_model.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final MatchingDataSourceImpl remoteDataSource;
  final FirebaseAuth firebaseAuth;

  MatchingRepositoryImpl(this.remoteDataSource, this.firebaseAuth);

  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<Map<String, dynamic>> sendRequest(Map<String, String> rideData) {
    return remoteDataSource.sendJoinRequest(rideData);
  }

  @override
  Future<List<dynamic>> requestRide(
      String rideRequestId, Map<String, dynamic> requestData) {
    return remoteDataSource.sendRideRequest(rideRequestId, requestData);
  }

  @override
  Future<List<MatchingRideModel>> getRideRequestMatches(String rideRequestId) async {
    return remoteDataSource.getRideRequestMatches(rideRequestId, await getUserToken());
  }
}
