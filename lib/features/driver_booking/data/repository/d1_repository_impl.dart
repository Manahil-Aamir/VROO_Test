import '../../domain/repository/d1_repository.dart';
import '../data_source/d1_data_source.dart';

class D1RepositoryImpl implements D1Repository {
  final D1DataSource dataSource;

  D1RepositoryImpl(this.dataSource);

  @override
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) {
    return dataSource.saveSchedule(scheduleData);
  }

  @override
  Future<Map<String, dynamic>?> loadSchedule() {
    return dataSource.loadSchedule();
  }
}
