// import '../repository/d1_repository.dart';

// class ClearScheduleDataUseCase {
//   final D1Repository repository;

//   ClearScheduleDataUseCase(this.repository);

//   Future<void> execute() {
//     return repository.clearScheduleData();
//   }
// }

import '../repository/driver_home_repository.dart';

class ClearPreferencesUseCase {
  final DriverHomeRepository repository;

  ClearPreferencesUseCase(this.repository);

  Future<void> execute() async {
    return await repository.clearSharedPreferences();
  }
}