import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/d1_data_source.dart';
import '../data/repository/d1_repository_impl.dart';
import '../domain/repository/d1_repository.dart';
import '../domain/usecases/D1_usecase.dart';
import '../presentation/bloc/bloc/d1_bloc.dart';

class D1DependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the ScheduleDataSource, ScheduleRepository, and UseCase
    final scheduleDataSource = D1DataSource();
    final scheduleRepository = D1RepositoryImpl(scheduleDataSource);
    final saveScheduleUseCase = SaveScheduleUseCase(scheduleRepository);
    final loadScheduleUseCase = LoadScheduleUseCase(scheduleRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<D1DataSource>(create: (_) => scheduleDataSource),
      Provider<D1Repository>(create: (_) => scheduleRepository),
      Provider<SaveScheduleUseCase>(create: (_) => saveScheduleUseCase),
      Provider<LoadScheduleUseCase>(create: (_) => loadScheduleUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<D1Bloc>(
          create: (_) => D1Bloc(saveScheduleUseCase, loadScheduleUseCase)),
    ];
  }
}
