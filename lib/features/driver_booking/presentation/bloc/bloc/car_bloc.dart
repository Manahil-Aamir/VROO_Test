import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/car_usecase.dart';
import '../event/car_event.dart';
import '../state/car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCarsUseCase getCarsUseCase;
  final AddCarUseCase addCarUseCase;

  CarBloc(this.getCarsUseCase, this.addCarUseCase) : super(CarInitial()) {
    on<FetchCars>(_onFetchCars);
    on<AddCar>(_onAddCar);
  }

  void _onFetchCars(FetchCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await getCarsUseCase.execute();
      emit(CarLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }

  void _onAddCar(AddCar event, Emitter<CarState> emit) async {
    try {
      await addCarUseCase.execute(event.car);
      final cars = await getCarsUseCase.execute();
      emit(CarLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }
}
