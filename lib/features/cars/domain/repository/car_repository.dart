import '../../data/model/carr_model.dart';

abstract class CarRepository {
  Future<List<Car>> getCars();
  Future<void> addCar(Car car);
  Future<List<Car>> deleteCar(String carId); 
}
