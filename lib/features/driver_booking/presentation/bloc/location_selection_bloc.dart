import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'location_selection_event.dart';
import 'location_selection_state.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationSelectionBloc
    extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  LocationSelectionBloc() : super(LocationSelectionInitial()) {
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

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI&language=en';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = (data['predictions'] as List)
            .map((json) => Prediction.fromJson(json))
            .toList();
        emit(LocationSelectionLoaded(predictions));
      } else {
        emit(LocationSelectionError('Failed to load suggestions'));
      }
    } catch (e) {
      emit(LocationSelectionError('An error occurred: $e'));
    }
  }

  void _onSelectLocation(
      SelectLocation event, Emitter<LocationSelectionState> emit) {
    emit(LocationSelected(event.placeId, event.description));
  }
}
