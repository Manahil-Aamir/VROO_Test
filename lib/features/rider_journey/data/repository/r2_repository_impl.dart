import '../../domain/repository/r2_repository.dart';
import '../data_source/r2_data_source.dart';

class R2RepositoryImpl implements R2Repository {
  final R2DataSource dataSource;

  R2RepositoryImpl(this.dataSource);

  @override
  Future<void> savePreference(Map<String, dynamic> preferenceData) {
    return dataSource.savePreference(preferenceData);
  }

  @override
  Future<Map<String, dynamic>?> loadPreference() {
    return dataSource.loadPreference();
  }
}
