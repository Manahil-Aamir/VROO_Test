import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/rider_pending_request_entity.dart';
import '../../domain/repository/rider_pending_request_repository.dart';
import '../data_source/rider_pending_request_remote_data_source.dart';

class RiderPendingRequestRepositoryImpl implements RiderPendingRequestRepository {
  final RiderPendingRequestDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  RiderPendingRequestRepositoryImpl(this.dataSource, this.firebaseAuth);

  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<List<RiderPendingRequest>> getPendingRequests() async {
    final modelList = await dataSource.getPendingRequests(await getUserToken());
    return modelList.map((model) => model.toEntity()).toList();
  }
}