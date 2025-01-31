import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../data/data_source/location_data_source.dart';
import '../data/repository/location_repository_impl.dart';
import '../domain/repository/location_repository.dart';
import '../domain/usecases/fetch_suggestion_usecase.dart';
import '../domain/usecases/save_location_usecase.dart';
import '../presentation/bloc/bloc/location_selection_bloc.dart';

class LocationSelectionDependencyInjection {
  static List<SingleChildWidget> init() {
    final client = http.Client();
    final locationDataSource = LocationDataSource(client,
        apiKey: 'AIzaSyClFyao6GuHD2iaFLzxsz8kAmHUvTAWokI');
    final locationRepository = LocationRepositoryImpl(locationDataSource);

    final fetchSuggestionsUseCase = FetchSuggestionsUseCase(locationRepository);
    final getSelectedLocationUseCase =
        GetSelectedLocationUseCase(locationRepository);
    final saveSelectedLocationUseCase =
        SaveSelectedLocationUseCase(locationRepository);
    final navigationProvider = Navigation();

    return [
      Provider<http.Client>(create: (_) => client),
      Provider<LocationDataSource>(create: (_) => locationDataSource),
      Provider<LocationRepository>(create: (_) => locationRepository),
      Provider<FetchSuggestionsUseCase>(create: (_) => fetchSuggestionsUseCase),
      Provider<GetSelectedLocationUseCase>(
          create: (_) => getSelectedLocationUseCase),
      Provider<SaveSelectedLocationUseCase>(
          create: (_) => saveSelectedLocationUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<LocationSelectionBloc>(
        create: (_) => LocationSelectionBloc(
          fetchSuggestionsUseCase,
          saveSelectedLocationUseCase,
          getSelectedLocationUseCase,
        ),
      ),
    ];
  }
}
