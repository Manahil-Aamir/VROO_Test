import 'package:equatable/equatable.dart';
import '../../../domain/entity/prediction_entity.dart';

abstract class LocationSelectionEvent extends Equatable {
  const LocationSelectionEvent();
}

class FetchSuggestions extends LocationSelectionEvent {
  final String input;

  const FetchSuggestions(this.input);

  @override
  List<Object> get props => [input];
}

class SaveSelectedLocation extends LocationSelectionEvent {
  final Location prediction;

  const SaveSelectedLocation(this.prediction);

  @override
  List<Object> get props => [prediction];
}

class GetSelectedLocation extends LocationSelectionEvent {
  @override
  List<Object> get props => [];
}
