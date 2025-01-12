import 'package:google_places_flutter/model/prediction.dart';
import '../../domain/repository/location_repository.dart';
import '../data_source/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<Prediction>> fetchSuggestions(String input) {
    return dataSource.fetchSuggestions(input);
  }
}
