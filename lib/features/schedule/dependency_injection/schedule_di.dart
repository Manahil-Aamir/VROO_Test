import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/schedule_data_source.dart';
import '../data/repository/schedule_repository_impl.dart';
import '../domain/repository/schedule_repository.dart';
import '../domain/usecase/delete_schedule.dart';
import '../domain/usecase/get_schedules.dart';
import '../presentation/bloc/bloc/schedule_bloc.dart';

class ScheduleDependencyInjection {
  static List<SingleChildWidget> init() {
    // Initialize dependencies
    final client = http.Client();
    final firebaseAuth = FirebaseAuth.instance; 

    // final scheduleDataSource = MockScheduleRemoteDataSource();
    final scheduleDataSource = ScheduleRemoteDataSourceImpl(client: client);
    final scheduleRepository = ScheduleRepositoryImpl(firebaseAuth, remoteDataSource: scheduleDataSource);
    final getSchedulesUseCase = GetSchedules(scheduleRepository);
    final deleteScheduleUseCase = DeleteSchedule(scheduleRepository);

    // Return providers
    return [
      Provider<ScheduleRemoteDataSource>(create: (_) => scheduleDataSource),
      Provider<ScheduleRepository>(create: (_) => scheduleRepository),
      Provider<GetSchedules>(create: (_) => getSchedulesUseCase),
      BlocProvider<ScheduleBloc>(create: (_) => ScheduleBloc(
        getSchedules: getSchedulesUseCase, deleteSchedule: deleteScheduleUseCase)),
    ];
  }
}