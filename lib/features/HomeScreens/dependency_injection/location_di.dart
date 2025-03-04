import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/location_data_source.dart';
import '../data/repository/location_repository_impl.dart';
import '../domain/usecase/fetch_suggestions_usecase.dart';
import '../domain/usecase/location_usecase.dart';
import '../presentation/bloc/bloc/location_selection_bloc.dart';

class LocationDependencyInjection {
  static List<BlocProvider> init() {
    final dataSource = LocationDataSource(
      http.Client(),
      apiKey: 'AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI'
    );
    final repository = LocationRepositoryImpl(dataSource);
    
    return [
      BlocProvider<LocationSelectionBloc>(
        create: (_) => LocationSelectionBloc(
          fetchSuggestions: FetchSuggestionsUseCase(repository),
          saveLocation: SaveLocationUseCase(repository),
          getLocation: GetLocationUseCase(repository),
        ),
      ),
    ];
  }
}