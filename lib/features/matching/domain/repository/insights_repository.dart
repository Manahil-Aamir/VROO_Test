import '../../data/models/insights_model.dart';

abstract class DriverInsightsRepository {
  Future<InsightModel> getDriverInsights(String driverId);
}
