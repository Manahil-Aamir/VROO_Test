import '../../domain/repository/route_repository.dart';
import '../data_source/route_data_source.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteDataSource dataSource;

  RouteRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, dynamic>?> getRoutes(String fromPlaceId, String toPlaceId) {
    return dataSource.fetchRoutes(fromPlaceId, toPlaceId);
  }
}
