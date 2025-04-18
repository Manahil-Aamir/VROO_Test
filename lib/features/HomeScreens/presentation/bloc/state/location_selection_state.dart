import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entity/prediction.dart';

abstract class LocationSelectionState extends Equatable {
  const LocationSelectionState();
}

class LocationSelectionInitial extends LocationSelectionState {
  @override
  List<Object> get props => [];
}

class LocationSelectionLoading extends LocationSelectionState {
  @override
  List<Object> get props => [];
}

class LocationSelectionLoaded extends LocationSelectionState {
  final List<Prediction> predictions;
  const LocationSelectionLoaded(this.predictions);

  @override
  List<Object> get props => [predictions];
}

class LocationSelectionError extends LocationSelectionState {
  final String message;
  const LocationSelectionError(this.message);

  @override
  List<Object> get props => [message];
}

class PlaceIdLoaded extends LocationSelectionState {
  final String placeId;

  const PlaceIdLoaded(this.placeId);

  @override
  List<Object> get props => [placeId];
}

class LatLngLoaded extends LocationSelectionState {
  final LatLng latLng;

  const LatLngLoaded(this.latLng);

  @override
  List<Object> get props => [latLng];
}
