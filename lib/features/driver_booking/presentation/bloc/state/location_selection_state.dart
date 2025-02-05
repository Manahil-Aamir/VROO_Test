import 'package:equatable/equatable.dart';
import '../../../domain/entity/prediction.dart';

abstract class LocationSelectionState extends Equatable {
  const LocationSelectionState();

  @override
  List<Object> get props => [];
}

class LocationSelectionInitial extends LocationSelectionState {}

class LocationSelectionLoading extends LocationSelectionState {}

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
