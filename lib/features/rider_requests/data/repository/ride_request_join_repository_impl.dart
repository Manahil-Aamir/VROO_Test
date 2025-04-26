import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/ride_request_join.dart';
import '../../domain/repository/ride_request_join_repository.dart';
import '../data_source/ride_request_join_remote_datasource.dart';

class RideRequestJoinRepositoryImpl implements RideRequestJoinRepository {
  final RideRequestJoinRemoteDatasource remoteDatasource;
  final FirebaseAuth firebaseAuth;

  RideRequestJoinRepositoryImpl(this.remoteDatasource, this.firebaseAuth);

  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }


  @override
  Future<List<RideRequestJoinEntity>> getPendingRideRequestJoins(String RideRequestId) async {
    final models = await remoteDatasource.getPendingRideRequestJoins(await getUserToken(), RideRequestId);
    return models.map((model) => model.toEntity()).toList();
  }
}
