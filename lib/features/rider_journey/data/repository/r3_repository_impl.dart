import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/r3_repository.dart';
import '../data_source/r3_data_source.dart';

class R3RepositoryImpl implements R3Repository {
  final R3DataSource remoteDataSource;

  R3RepositoryImpl(this.remoteDataSource);

  @override
  Future<LatLng> getCoordinates(String placeId) {
    return remoteDataSource.fetchCoordinates(placeId);
  }

  @override
  Future<RideResponseModel> requestRide(Map<String, dynamic> requestData) {
    return remoteDataSource.sendRideRequest(requestData);
  }
}
