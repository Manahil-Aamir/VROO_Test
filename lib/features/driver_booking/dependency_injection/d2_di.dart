import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/car_data_source.dart';
import '../data/data_source/d2_datasource.dart';
import '../data/repository/car_repository_impl.dart';
import '../data/repository/d2_repository_impl.dart';
import '../domain/repository/car_repository.dart';
import '../domain/repository/d2_repository.dart';
import '../domain/usecases/car_usecase.dart';
import '../domain/usecases/driver_schedule2_usecase.dart';
import '../presentation/bloc/bloc/car_bloc.dart';
import '../presentation/bloc/bloc/d2_bloc.dart';

class D2DependencyInjection {
  static List<SingleChildWidget> init() {
    final navigationProvider = Navigation();
    // Car Preferences Dependencies
    final d2DataSource = D2DataSource();
    final d2Repository = D2RepositoryImpl(d2DataSource);
    final savePrefsUseCase = SaveCarPreferencesUseCase(d2Repository);
    final loadPrefsUseCase = LoadCarPreferencesUseCase(d2Repository);

    // Car List Dependencies
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();
    final carDataSource = CarRemoteDataSourceImpl(client);
    final carRepository = CarRepositoryImpl(apiDataSource: carDataSource, firebaseAuth: firebaseAuth, );
    final getCarsUseCase = GetCarsUseCase(carRepository);
    final addCarUseCase = AddCarUseCase(carRepository);

    return [
      // Preferences
      Provider<D2DataSource>(create: (_) => d2DataSource),
      Provider<D2Repository>(create: (_) => d2Repository),
      Provider<SaveCarPreferencesUseCase>(create: (_) => savePrefsUseCase),
      Provider<LoadCarPreferencesUseCase>(create: (_) => loadPrefsUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<CarPreferencesBloc>(
        create: (_) => CarPreferencesBloc(savePrefsUseCase, loadPrefsUseCase),
      ),

      // Car List
      Provider<CarRemoteDataSource>(create: (_) => carDataSource),
      Provider<CarRepository>(create: (_) => carRepository),
      Provider<GetCarsUseCase>(create: (_) => getCarsUseCase),
      Provider<AddCarUseCase>(create: (_) => addCarUseCase),
      BlocProvider<CarBloc>(
        create: (_) => CarBloc(getCarsUseCase, addCarUseCase),
      ),
    ];
  }
}