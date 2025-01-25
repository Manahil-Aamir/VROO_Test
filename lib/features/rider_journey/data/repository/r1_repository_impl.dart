import '../../domain/repository/r1_repository.dart';
import '../data_source/r1_data_source.dart';

class R1RepositoryImpl implements R1Repository {
  final R1DataSource dataSource;

  R1RepositoryImpl(this.dataSource);

  @override
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) {
    return dataSource.saveSchedule(scheduleData);
  }

  @override
  Future<Map<String, dynamic>?> loadSchedule() {
    return dataSource.loadSchedule();
  }
}
