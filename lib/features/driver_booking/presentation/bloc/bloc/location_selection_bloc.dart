import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_suggestions_usecase.dart';
import '../event/location_selection_event.dart';
import '../state/location_selection_state.dart';

class LocationSelectionBloc extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final FetchSuggestionsUseCase fetchSuggestionsUseCase;

  LocationSelectionBloc(this.fetchSuggestionsUseCase) : super(LocationSelectionInitial()) {
    on<FetchSuggestions>(_onFetchSuggestions);
  }

  void _onFetchSuggestions(FetchSuggestions event, Emitter<LocationSelectionState> emit) async {
    emit(LocationSelectionLoading());
    try {
      final predictions = await fetchSuggestionsUseCase.execute(event.input);
      emit(LocationSelectionLoaded(predictions));
    } catch (e) {
      emit(LocationSelectionError(e.toString()));
    }
  }
}

