abstract class RouteRepository {
  Future<Map<String, dynamic>?> getRoutes(String fromPlaceId, String toPlaceId);
}
