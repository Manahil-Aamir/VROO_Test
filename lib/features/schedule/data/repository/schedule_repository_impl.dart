import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/schedule_entity.dart';
import '../../domain/repository/schedule_repository.dart';
import '../data_source/schedule_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  ScheduleRepositoryImpl(this.firebaseAuth, {required this.remoteDataSource});

  Future<String> getUserToken() async {
    final user = firebaseAuth.currentUser!;
    final token = await user.getIdToken();
    return token!;
  }

  @override
  Future<List<ScheduleEntity>> getSchedules(String role) async {
    final scheduleModels = await remoteDataSource.getSchedules(role, await getUserToken());
    // Convert models to entities
    return scheduleModels.map((model) => model.toEntity()).toList();
  }

  Future<void> deleteSchedule(String id, String role) async {
    final token = await getUserToken();
    await remoteDataSource.deleteSchedule(id, role, token);
  }
}
