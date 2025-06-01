import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entity/driver_history_entity.dart';
import '../../domain/entity/rider_history_entity.dart';
import '../../domain/repository/ride_history_repository.dart';
import '../data_source/ride_history_remote_data_source.dart';

class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final RideHistoryRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  RideHistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseAuth,
  });

  Future<String> _getToken() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        return token!;
      } catch (e) {
        throw Exception("Failed to get token: ${e.toString()}");
      }
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Future<DriverHistoryEntity> getDriverRideHistory() async {
    final token = await _getToken();
    final model = await remoteDataSource.getDriverRideHistory(token);
    return model.toEntity();
  }

  @override
  Future<RiderHistoryEntity> getRiderRideHistory() async {
    final token = await _getToken();
    final model = await remoteDataSource.getRiderRideHistory(token);
    return model.toEntity();
  }
}
