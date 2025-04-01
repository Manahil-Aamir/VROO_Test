import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/approved_rides.dart';
import '../../domain/repository/approved_rides_repository.dart';
import '../data_source/approved_rides_data_source.dart';

class ApprovedRidesRepositoryImpl implements ApprovedRidesRepository {
  final ApprovedRidesDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  ApprovedRidesRepositoryImpl(this.dataSource, this.firebaseAuth);

  @override
  Future<List<ApprovedRidesEntity>> getApprovedRides(String rideId) async {
    // Get user after successful login
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not found after login");
    }

    // Get ID token
    final token = await user.getIdToken();
    final rides = await dataSource.getApprovedRides(rideId, token!);
    return rides.map<ApprovedRidesEntity>((model) => model.toEntity()).toList();
  }
}
