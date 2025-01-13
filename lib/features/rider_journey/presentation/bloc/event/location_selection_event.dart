import 'package:equatable/equatable.dart';

abstract class LocationSelectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSuggestions extends LocationSelectionEvent {
  final String input;

  FetchSuggestions(this.input);

  @override
  List<Object?> get props => [input];
}

class SelectLocation extends LocationSelectionEvent {
  final String placeId;
  final String description;

  SelectLocation(this.placeId, this.description);

  @override
  List<Object?> get props => [placeId, description];
}
