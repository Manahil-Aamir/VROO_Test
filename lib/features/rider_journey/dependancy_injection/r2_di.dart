import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/rider_journey/data/repository/r2_repository_impl.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/r2_repository.dart';
import 'package:vroo_test/features/rider_journey/domain/usecases/r2_usecase.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/r2_data_source.dart';
import '../presentation/bloc/bloc/r2_bloc.dart';

class R2DependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the ScheduleDataSource, ScheduleRepository, and UseCase
    final preferenceDataSource = R2DataSource();
    final preferenceRepository = R2RepositoryImpl(preferenceDataSource);
    final savePreferenceUseCase = SavePreferenceUseCase(preferenceRepository);
    final loadPreferenceUseCase = LoadPreferenceUseCase(preferenceRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<R2DataSource>(create: (_) => preferenceDataSource),
      Provider<R2Repository>(create: (_) => preferenceRepository),
      Provider<SavePreferenceUseCase>(create: (_) => savePreferenceUseCase),
      Provider<LoadPreferenceUseCase>(create: (_) => loadPreferenceUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<R2Bloc>(
          create: (_) => R2Bloc(savePreferenceUseCase, loadPreferenceUseCase)),
    ];
  }
}
