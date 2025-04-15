import 'package:equatable/equatable.dart';

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
