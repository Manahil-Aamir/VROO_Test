import '../../../domain/entity/car.dart';

abstract class CarEvent {}

class FetchCars extends CarEvent {}

class AddCar extends CarEvent {
  final CarEntity car;

  AddCar(this.car);
}

class DeleteCar extends CarEvent {
  final String carId;

  DeleteCar(this.carId);
}

class UpdateCar extends CarEvent {
  final String carId;
  final double mileage;

  UpdateCar(this.carId, this.mileage);
}
