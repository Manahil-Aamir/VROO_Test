import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entity/prediction.dart';
import '../../domain/repository/location_repository.dart';
import '../data_source/location_data_source.dart';
import '../models/prediction_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<Prediction>> fetchSuggestions(String input) async {
    final models = await dataSource.fetchSuggestions(input);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveSelectedLocation(Prediction prediction, String role) async {
    return dataSource.saveSelectedLocation(
      prediction: PredictionModel.fromEntity(prediction),
      role: role,
    );
  }

  @override
  Future<Prediction?> getSelectedLocation(String role) async {
    final model = await dataSource.getSelectedLocation(role);
    return model?.toEntity();
  }

  @override
  Future<String?> getPlaceId(double lat, double lng) async {
    return dataSource.getPlaceId(lat, lng);
  }

  @override
  Future<LatLng> getLatLng(String placeId) async {
    return dataSource.getPlacePosition(placeId);
  }
}
