import '../../../domain/entity/car.dart';

abstract class CarState {}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<CarEntity> cars;

  CarLoaded(this.cars);
}

class CarError extends CarState {
  final String message;

  CarError(this.message);
}

class CarAdded extends CarState {
  final List<CarEntity> cars;

  CarAdded(this.cars);
}

class CarEmpty extends CarState {}
