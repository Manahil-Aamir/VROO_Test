import '../../../domain/entity/car.dart';

abstract class CarEvent {}

class FetchCars extends CarEvent {}

class AddCar extends CarEvent {
  final CarEntity car;

  AddCar(this.car);
}
