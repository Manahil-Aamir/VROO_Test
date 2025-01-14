import '../repository/route_repository.dart';

class FetchRoutesUseCase {
  final RouteRepository repository;

  FetchRoutesUseCase(this.repository);

  Future<Map<String, dynamic>?> call(String fromPlaceId, String toPlaceId) {
    return repository.getRoutes(fromPlaceId, toPlaceId);
  }
}
