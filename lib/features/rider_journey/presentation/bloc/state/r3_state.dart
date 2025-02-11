import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vroo_test/features/rider_journey/data/model/matching_rides_model.dart';

abstract class R3State {}

class RideRequestInitial extends R3State {}

class RideRequestLoading extends R3State {}

class RideRequestSuccess extends R3State {
  final RideResponseModel response;
  RideRequestSuccess(this.response);
}

class RideRequestFailure extends R3State {
  final String error;
  RideRequestFailure(this.error);
}

class CoordinatesLoaded extends R3State {
  final LatLng coordinates;
  final bool isSource;
  CoordinatesLoaded(this.coordinates, {this.isSource = true});
}
