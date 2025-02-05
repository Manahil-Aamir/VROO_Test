import '../../domain/repository/matching_repository.dart';
import '../data_source/matching_data_source.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final MatchingDataSource remoteDataSource;

  MatchingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> sendRequest(Map<String, String> rideData) {
    return remoteDataSource.sendJoinRequest(rideData);
  }

  @override
  Future<List<dynamic>> requestRide(
      String rideRequestId, Map<String, dynamic> requestData) {
    return remoteDataSource.sendRideRequest(rideRequestId, requestData);
  }
}
