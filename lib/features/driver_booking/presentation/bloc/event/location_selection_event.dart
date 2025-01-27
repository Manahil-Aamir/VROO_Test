import 'package:equatable/equatable.dart';

abstract class LocationSelectionEvent extends Equatable {
  const LocationSelectionEvent();

  @override
  List<Object> get props => [];
}

class FetchSuggestions extends LocationSelectionEvent {
  final String input;

  const FetchSuggestions(this.input);

  @override
  List<Object> get props => [input];
}
