import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/location_data_source.dart';
import '../data/repository/location_repository_impl.dart';
import '../domain/repository/location_repository.dart';
import '../domain/usecases/fetch_suggestions_usecase.dart';
import '../presentation/bloc/bloc/location_selection_bloc.dart';

class LocationDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the data source, repository, and use cases
    final locationDataSource = LocationDataSourceImpl(http.Client());
    final locationRepository = LocationRepositoryImpl(locationDataSource);
    final fetchSuggestionsUseCase = FetchSuggestionsUseCase(locationRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<LocationDataSource>(create: (_) => locationDataSource),
      Provider<LocationRepository>(create: (_) => locationRepository),
      Provider<FetchSuggestionsUseCase>(create: (_) => fetchSuggestionsUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<LocationSelectionBloc>(
        create: (_) => LocationSelectionBloc(fetchSuggestionsUseCase),
      ),
    ];
  }
}
