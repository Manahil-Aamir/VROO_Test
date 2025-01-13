import 'package:equatable/equatable.dart';
import 'package:google_places_flutter/model/prediction.dart';

abstract class LocationSelectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationSelectionInitial extends LocationSelectionState {}

class LocationSelectionLoading extends LocationSelectionState {}

class LocationSelectionLoaded extends LocationSelectionState {
  final List<Prediction> suggestions;

  LocationSelectionLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class LocationSelected extends LocationSelectionState {
  final String placeId;
  final String description;

  LocationSelected(this.placeId, this.description);

  @override
  List<Object?> get props => [placeId, description];
}

class LocationSelectionError extends LocationSelectionState {
  final String message;

  LocationSelectionError(this.message);

  @override
  List<Object?> get props => [message];
}
