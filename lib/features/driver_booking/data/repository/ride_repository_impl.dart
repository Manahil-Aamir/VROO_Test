import '../../domain/entity/ride_request.dart';
import '../../domain/repository/ride_request_repository.dart';
import '../data_source/ride_request_data_source.dart';
import '../model/ride_request_modal.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDataSource remoteDataSource;

  RideRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitRideRequest(RideRequest request) async {
    final rideRequestModel = RideRequestModel(
      driverId: request.driverId,
      numOfSeats: request.numOfSeats,
      car: request.car,
      coords: request.coords,
      source: request.source,
      destination: request.destination,
      samegender: request.samegender,
      departureTime: request.departureTime,
      maxArrivalTime: request.maxArrivalTime,
      distance: request.distance,
      duration: request.duration,
      date: request.date,
      fare: request.fare,
      paymentMethod: request.paymentMethod,
    );
    return remoteDataSource.submitRideRequest(rideRequestModel);
  }
}