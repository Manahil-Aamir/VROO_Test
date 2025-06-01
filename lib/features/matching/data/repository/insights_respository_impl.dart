import 'package:firebase_auth/firebase_auth.dart';
import '../data_source/insights_data_sources.dart';
import '../../domain/repository/insights_repository.dart';
import '../models/insights_model.dart';

class DriverInsightsRepositoryImpl implements DriverInsightsRepository {
  final DriverInsightsDataSource dataSource;
  final FirebaseAuth firebaseAuth;

  DriverInsightsRepositoryImpl(this.dataSource, {required this.firebaseAuth});

  Future<String> getToken() async {
    try {
      final user = firebaseAuth.currentUser!;
      final token = await user.getIdToken();
      return token!;
    } catch (e) {
      print('Error getting token: $e'); 
      rethrow;
    }
  }

  @override
  Future<InsightModel> getDriverInsights(String driverId) async {
    try {
      print('Repository: Getting driver insights for $driverId'); 
      final token = await getToken();
      return await dataSource.fetchDriverInsights(driverId, token);
    } catch (e) {
      print('Error in repository getDriverInsights: $e'); 
      rethrow;
    }
  }
}
