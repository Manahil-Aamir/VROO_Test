import 'package:http/http.dart' as http;
import '../data/data_source/location_data_source.dart';
import '../data/repository/location_repository_impl.dart';
import '../domain/repository/location_repository.dart';
import '../domain/usecases/fetch_suggestions_usecase.dart';

class DependencyInjector {
  static late final LocationRepository locationRepository;
  static late final FetchSuggestionsUseCase fetchSuggestionsUseCase;

  static void setup() {
    final dataSource = LocationDataSourceImpl(http.Client());
    locationRepository = LocationRepositoryImpl(dataSource);
    fetchSuggestionsUseCase = FetchSuggestionsUseCase(locationRepository);
  }
}
