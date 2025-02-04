import '../../domain/repository/d2_repository.dart';
import '../data_source/d2_datasource.dart';

class D2RepositoryImpl implements D2Repository {
  final D2DataSource dataSource;

  D2RepositoryImpl(this.dataSource);

  @override
  Future<void> saveCarPreferences(Map<String, dynamic> preferencesData) =>
      dataSource.saveCarPreferences(preferencesData);

  @override
  Future<Map<String, dynamic>?> loadCarPreferences() =>
      dataSource.loadCarPreferences();

  // @override
  // Future<void> clearCarPreferences() => dataSource.clearCarPreferences();
}