import '../../domain/entity/prediction.dart';
import '../../domain/repository/location_repository.dart';
import '../data_source/location_data_source.dart';
import '../data_source/location_local_data_source.dart';
import '../model/prediction_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<Prediction>> fetchSuggestions(String input) async {
    final predictions = await dataSource.fetchSuggestions(input);
    return predictions.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveSelectedLocation(Prediction prediction) async {
    return dataSource.saveSelectedLocation(PredictionModel(
      description: prediction.description,
      placeId: prediction.placeId,
    ));
  }

  @override
  Future<Prediction?> getSelectedLocation() async {
    final predictionModel = await dataSource.getSelectedLocation();
    return predictionModel?.toEntity();
  }
}
