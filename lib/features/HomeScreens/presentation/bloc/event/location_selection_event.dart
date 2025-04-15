import 'package:equatable/equatable.dart';

import '../../../domain/entity/prediction.dart';

abstract class LocationSelectionEvent extends Equatable {
  const LocationSelectionEvent();
}

class FetchSuggestionsEvent extends LocationSelectionEvent {
  final String input;
  const FetchSuggestionsEvent(this.input);

  @override
  List<Object> get props => [input];
}

class SaveLocationEvent extends LocationSelectionEvent {
  final Prediction prediction;
  final String role;
  const SaveLocationEvent(this.prediction, this.role);

  @override
  List<Object> get props => [prediction, role];
}

class GetLocationEvent extends LocationSelectionEvent {
  final String role;
  const GetLocationEvent(this.role);

  @override
  List<Object> get props => [role];
}

class FetchPlaceIdFromLatLngEvent extends LocationSelectionEvent {
  final double lat;
  final double lng;

  const FetchPlaceIdFromLatLngEvent(this.lat, this.lng);

  @override
  List<Object> get props => [lat, lng];
}

// Add to your existing events
class FetchLatLngFromPlaceIdEvent extends LocationSelectionEvent {
  final String placeId;

  const FetchLatLngFromPlaceIdEvent(this.placeId);

  @override
  List<Object> get props => [placeId];
}
