import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class R3State {}

class RideRequestInitial extends R3State {}

class RideRequestLoading extends R3State {}

class RideRequestSuccess extends R3State {
  final Map<String, dynamic> response;
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
