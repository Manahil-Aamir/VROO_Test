import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/d1_data_source.dart';
import '../data/data_source/driver_home_data_source.dart';
import '../data/repository/driver_home_repository.dart';
import '../domain/repository/driver_home_repository.dart';
import '../domain/usecases/ClearScheduleUseCase.dart';
import '../domain/usecases/get_driver_current_location.dart';
import '../presentation/bloc/bloc/driver_home_bloc.dart';

class DriverHomeDependencyInjection {
  static List<SingleChildWidget> init() {
    final homeRepository = DriverHomeRepositoryImpl(MockDriverHomeDataSource());
    final getDriverCurrentLocation = GetDriverCurrentLocation(homeRepository);
    final clearPreferencesUsecase = ClearPreferencesUseCase(homeRepository);
    final d1DataSource = D1DataSource();
    final navigationProvider = Navigation();

    return [
      Provider<DriverHomeRepository>(create: (_) => homeRepository),
      Provider<GetDriverCurrentLocation>(create: (_) => getDriverCurrentLocation),
      Provider<D1DataSource>(create: (_) => d1DataSource),
      Provider<Navigation>(create: (_) => navigationProvider),
      Provider<ClearPreferencesUseCase>(create: (_) => clearPreferencesUsecase),
      BlocProvider<DriverHomeBloc>(
        create: (_) => DriverHomeBloc(getDriverCurrentLocation, clearPreferencesUsecase),
      ),
    ];
  }
}

