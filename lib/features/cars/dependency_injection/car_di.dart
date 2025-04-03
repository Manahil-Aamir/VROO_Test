import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../cars/data/data_source/car_data_source.dart';
import '../../cars/data/repository/car_repository_impl.dart';
import '../../cars/domain/repository/car_repository.dart';
import '../../cars/domain/usecase/car_usecase.dart';
import '../../driver_booking/presentation/bloc/bloc/car_bloc.dart';

class CarDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();
    final carDataSource = CarRemoteDataSourceImpl(client);
    final carRepository = CarRepositoryImpl(
      apiDataSource: carDataSource, 
      firebaseAuth: firebaseAuth,
    );
    final getCarsUseCase = GetCarsUseCase(carRepository);
    final addCarUseCase = AddCarUseCase(carRepository);

    return [
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