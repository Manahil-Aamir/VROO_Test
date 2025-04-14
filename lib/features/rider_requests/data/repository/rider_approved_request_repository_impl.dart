import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/rider_approved_request_entity.dart';
import '../../domain/repository/rider_approved_request_repository.dart';
import '../data_source/rider_approved_request_remote_data_source.dart';

class RiderApprovedRequestRepositoryImpl implements RiderApprovedRequestRepository {
  final RiderApprovedRequestDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  RiderApprovedRequestRepositoryImpl(this.dataSource, this.firebaseAuth);

  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<List<RiderApprovedRequest>> getApprovedRequests() async {
    final modelList = await dataSource.getApprovedRequests(await getUserToken());
    return modelList.map((model) => model.toEntity()).toList();
  }
}
