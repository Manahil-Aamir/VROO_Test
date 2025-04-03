import '../../data/model/carr_model.dart';
import '../entity/car.dart';
import '../repository/car_repository.dart';

class GetCarsUseCase {
  final CarRepository repository;

  GetCarsUseCase(this.repository);

  Future<List<CarEntity>> execute() async {
    final cars = await repository.getCars();
    return cars.map((car) => CarEntity(
      company: car.company,
      model: car.model,
      color: car.color,
      numberPlate: car.numberPlate,
      mileage: car.mileage,
      isVerified: car.isVerified,
    )).toList();
  }
}

class AddCarUseCase {
  final CarRepository repository;

  AddCarUseCase(this.repository);

  Future<void> execute(CarEntity car) async {
    await repository.addCar(Car(
      company: car.company,
      model: car.model,
      color: car.color,
      numberPlate: car.numberPlate,
      mileage: car.mileage,
      isVerified: false,
    ));
  }
}