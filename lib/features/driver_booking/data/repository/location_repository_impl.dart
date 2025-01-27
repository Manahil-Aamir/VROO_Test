import '../../domain/entity/prediction.dart';
import '../../domain/repository/location_repository.dart';
import '../data_source/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<Prediction>> fetchSuggestions(String input) async {
    final predictions = await dataSource.fetchSuggestions(input);
    return predictions.map((model) => model.toEntity()).toList();
  }
}
