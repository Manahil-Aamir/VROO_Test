import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_suggestion_usecase.dart';
import '../../../domain/usecases/save_location_usecase.dart';
import '../event/location_selection_event.dart';
import '../state/location_selection_state.dart';

class LocationSelectionBloc
    extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final FetchSuggestionsUseCase fetchSuggestionsUseCase;
  final SaveSelectedLocationUseCase saveSelectedLocationUseCase;
  final GetSelectedLocationUseCase getSelectedLocationUseCase;

  LocationSelectionBloc(this.fetchSuggestionsUseCase,
      this.saveSelectedLocationUseCase, this.getSelectedLocationUseCase)
      : super(LocationSelectionInitial()) {
    on<FetchSuggestions>(_onFetchSuggestions);
    on<SaveSelectedLocation>(_onSaveSelectedLocation);
    on<GetSelectedLocation>(_onGetSelectedLocation);
  }

  void _onFetchSuggestions(
      FetchSuggestions event, Emitter<LocationSelectionState> emit) async {
    emit(LocationSelectionLoading());
    try {
      final predictions = await fetchSuggestionsUseCase.execute(event.input);
      emit(LocationSelectionLoaded(predictions));
    } catch (e) {
      emit(LocationSelectionError(e.toString()));
    }
  }

  void _onSaveSelectedLocation(
      SaveSelectedLocation event, Emitter<LocationSelectionState> emit) async {
    await saveSelectedLocationUseCase.execute(event.prediction);
  }

  void _onGetSelectedLocation(
      GetSelectedLocation event, Emitter<LocationSelectionState> emit) async {
    final prediction = await getSelectedLocationUseCase.execute();
    if (prediction != null) {
      emit(LocationSelectionLoaded([prediction]));
    }
  }
}
