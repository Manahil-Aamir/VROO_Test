import '../../domain/repository/car_repository.dart';
import '../data_source/car_data_source.dart';
import '../model/carr_model.dart';

class CarRepositoryImpl implements CarRepository {
  final CarDataSource apiDataSource;

  CarRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<Car>> getCars() async {
    return apiDataSource.fetchCarsFromApi();
  }

  @override
  Future<void> addCar(Car car) async {
    return apiDataSource.addCarToApi(car);
  }
}

