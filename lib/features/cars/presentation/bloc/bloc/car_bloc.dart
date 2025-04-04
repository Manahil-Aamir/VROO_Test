import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/car_usecase.dart';
import '../event/car_event.dart';
import '../state/car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCarsUseCase getCarsUseCase;
  final AddCarUseCase addCarUseCase;
  final DeleteCarUseCase deleteCarUseCase;

  CarBloc(this.getCarsUseCase, this.addCarUseCase, this.deleteCarUseCase) : super(CarInitial()) {
    on<FetchCars>(_onFetchCars);
    on<AddCar>(_onAddCar);
    on<DeleteCar>(_onDeleteCar);
  }

  void _onFetchCars(FetchCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await getCarsUseCase.execute();
      if (cars.isEmpty) {
        emit(CarEmpty());
      } else {
        emit(CarLoaded(cars));
      }
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

  Future<void> _onDeleteCar(DeleteCar event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final cars = await deleteCarUseCase.execute(event.carId);
      // final cars = await getCarsUseCase.execute();
        if (cars.isEmpty) {
        emit(CarEmpty());
      } else {
        emit(CarLoaded(cars));
      }
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }
}
