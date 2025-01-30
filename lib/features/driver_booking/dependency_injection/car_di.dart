// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';
// import '../data/data_source/car_data_source.dart';
// import '../data/repository/car_repository_impl.dart';
// import '../domain/repository/car_repository.dart';
// import '../domain/usecases/car_usecase.dart';
// import '../presentation/bloc/bloc/car_bloc.dart';

// class CarDependencyInjection {
//   static List<SingleChildWidget> init() {
//     final carDataSource = CarDataSource();
//     final carRepository = CarRepositoryImpl(apiDataSource: carDataSource);
//     final getCarsUseCase = GetCarsUseCase(carRepository);
//     final addCarUseCase = AddCarUseCase(carRepository);
    
//     return [
//       Provider<CarDataSource>(create: (_) => carDataSource),
//       Provider<CarRepository>(create: (_) => carRepository),
//       Provider<GetCarsUseCase>(create: (_) => getCarsUseCase),
//       Provider<AddCarUseCase>(create: (_) => addCarUseCase),
//       BlocProvider<CarBloc>(
//         create: (_) => CarBloc(getCarsUseCase, addCarUseCase),
//       ),
//     ];
//   }
// }