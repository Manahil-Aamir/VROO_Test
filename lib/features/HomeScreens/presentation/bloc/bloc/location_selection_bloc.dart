import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/fetch_suggestions_usecase.dart';
import '../../../domain/usecase/location_usecase.dart';
import '../event/location_selection_event.dart';
import '../state/location_selection_state.dart';

class LocationSelectionBloc
    extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final FetchSuggestionsUseCase fetchSuggestions;
  final SaveLocationUseCase saveLocation;
  final GetLocationUseCase getLocation;

  LocationSelectionBloc({
    required this.fetchSuggestions,
    required this.saveLocation,
    required this.getLocation,
  }) : super(LocationSelectionInitial()) {
    on<FetchSuggestionsEvent>(_onFetchSuggestions);
    on<SaveLocationEvent>(_onSaveLocation);
    on<GetLocationEvent>(_onGetLocation);
    on<FetchPlaceIdFromLatLngEvent>(_onFetchPlaceIdFromLatLng);
    on<FetchLatLngFromPlaceIdEvent>(_onFetchLatLngFromPlaceId);
  }

  Future<void> _onFetchSuggestions(
    FetchSuggestionsEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(LocationSelectionLoading());
    try {
      final predictions = await fetchSuggestions.execute(event.input);
      emit(LocationSelectionLoaded(predictions));
    } catch (e) {
      emit(LocationSelectionError(e.toString()));
    }
  }

  Future<void> _onSaveLocation(
    SaveLocationEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    await saveLocation.execute(event.prediction, event.role);
  }

  Future<void> _onGetLocation(
    GetLocationEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    final location = await getLocation.execute(event.role);
    if (location != null) {
      emit(LocationSelectionLoaded([location]));
    }
  }

  Future<void> _onFetchPlaceIdFromLatLng(
    FetchPlaceIdFromLatLngEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(LocationSelectionLoading());
    try {
      final placeId = await fetchSuggestions.getPlaceId(event.lat, event.lng);
      if (placeId != null) {
        emit(PlaceIdLoaded(placeId));
      } else {
        emit(LocationSelectionError('Place ID not found'));
      }
    } catch (e) {
      emit(LocationSelectionError(e.toString()));
    }
  }

  Future<void> _onFetchLatLngFromPlaceId(
    FetchLatLngFromPlaceIdEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(LocationSelectionLoading());
    try {
      final latLng = await fetchSuggestions.getLatLng(event.placeId);
      emit(LatLngLoaded(latLng)); // You'll need to create this state
    } catch (e) {
      emit(
          LocationSelectionError('Failed to get coordinates: ${e.toString()}'));
    }
  }
}
