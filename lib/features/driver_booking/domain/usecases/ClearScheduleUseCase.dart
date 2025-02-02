import '../repository/d1_repository.dart';

class ClearScheduleDataUseCase {
  final D1Repository repository;

  ClearScheduleDataUseCase(this.repository);

  Future<void> execute() {
    return repository.clearScheduleData();
  }
}