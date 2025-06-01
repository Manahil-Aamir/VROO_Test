import '../../data/models/insights_model.dart';
import '../repository/insights_repository.dart';

class GetDriverInsightsUseCase {
  final DriverInsightsRepository repository;

  GetDriverInsightsUseCase(this.repository);

  Future<InsightModel> call(String driverId) async {
    try {
      print('UseCase: Getting driver insights for $driverId'); 
      return await repository.getDriverInsights(driverId);
    } catch (e) {
      print('Error in use case: $e');
      rethrow;
    }
  }
}
