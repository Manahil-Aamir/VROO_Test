import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/data_source/car_data_source.dart';
import '../data/data_source/driver_schedule2_datasource.dart';
import '../data/repository/car_repository_impl.dart';
import '../data/repository/driver_schedule2_repository_impl.dart';
import '../domain/repository/car_repository.dart';
import '../domain/repository/driver_schedule2_repository.dart';
import '../domain/usecases/car_usecase.dart';
import '../domain/usecases/driver_schedule2_usecase.dart';
import '../presentation/bloc/bloc/car_bloc.dart';
import '../presentation/bloc/bloc/driver_schedule2_bloc.dart';

class D2DependencyInjection {
  static List<SingleChildWidget> init() {
    // Car Preferences Dependencies
    final d2DataSource = D2DataSource();
    final d2Repository = D2RepositoryImpl(d2DataSource);
    final savePrefsUseCase = SaveCarPreferencesUseCase(d2Repository);
    final loadPrefsUseCase = LoadCarPreferencesUseCase(d2Repository);

    // Car List Dependencies
    final carDataSource = CarDataSource();
    final carRepository = CarRepositoryImpl(apiDataSource: carDataSource);
    final getCarsUseCase = GetCarsUseCase(carRepository);
    final addCarUseCase = AddCarUseCase(carRepository);

    return [
      // Preferences
      Provider<D2DataSource>(create: (_) => d2DataSource),
      Provider<D2Repository>(create: (_) => d2Repository),
      Provider<SaveCarPreferencesUseCase>(create: (_) => savePrefsUseCase),
      Provider<LoadCarPreferencesUseCase>(create: (_) => loadPrefsUseCase),
      BlocProvider<CarPreferencesBloc>(
        create: (_) => CarPreferencesBloc(savePrefsUseCase, loadPrefsUseCase),
      ),

      // Car List
      Provider<CarDataSource>(create: (_) => carDataSource),
      Provider<CarRepository>(create: (_) => carRepository),
      Provider<GetCarsUseCase>(create: (_) => getCarsUseCase),
      Provider<AddCarUseCase>(create: (_) => addCarUseCase),
      BlocProvider<CarBloc>(
        create: (_) => CarBloc(getCarsUseCase, addCarUseCase),
      ),
    ];
  }
}