import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/rider_journey/data/data_source/r1_data_source.dart';
import 'package:vroo_test/features/rider_journey/data/repository/r1_repository_impl.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/r1_repository.dart';
import '../../../core/router/navigation.dart';
import '../domain/usecases/r1_usecase.dart';
import '../presentation/bloc/bloc/r1_bloc.dart';

class R1DependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the ScheduleDataSource, ScheduleRepository, and UseCase
    final scheduleDataSource = R1DataSource();
    final scheduleRepository = R1RepositoryImpl(scheduleDataSource);
    final saveScheduleUseCase = SaveScheduleUseCase(scheduleRepository);
    final loadScheduleUseCase = LoadScheduleUseCase(scheduleRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<R1DataSource>(create: (_) => scheduleDataSource),
      Provider<R1Repository>(create: (_) => scheduleRepository),
      Provider<SaveScheduleUseCase>(create: (_) => saveScheduleUseCase),
      Provider<LoadScheduleUseCase>(create: (_) => loadScheduleUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<R1Bloc>(
          create: (_) => R1Bloc(saveScheduleUseCase, loadScheduleUseCase)),
    ];
  }
}
