import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../domain/usecases/fetch_suggestions_usecase.dart';
import 'location_selection_event.dart';
import 'location_selection_state.dart';

class LocationSelectionBloc extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final FetchSuggestionsUseCase fetchSuggestionsUseCase;

  LocationSelectionBloc(this.fetchSuggestionsUseCase) : super(LocationSelectionInitial()) {
    on<FetchSuggestions>(_onFetchSuggestions);
    on<SelectLocation>(_onSelectLocation);
  }

  Future<void> _onFetchSuggestions(
      FetchSuggestions event, Emitter<LocationSelectionState> emit) async {
    final input = event.input;

    if (input.isEmpty) {
      emit(LocationSelectionInitial());
      return;
    }

    emit(LocationSelectionLoading());

    try {
      final predictions = await fetchSuggestionsUseCase(input);
      emit(LocationSelectionLoaded(predictions));
    } catch (e) {
      emit(LocationSelectionError('An error occurred: $e'));
    }
  }

  void _onSelectLocation(
      SelectLocation event, Emitter<LocationSelectionState> emit) {
    emit(LocationSelected(event.placeId, event.description));
  }
}
