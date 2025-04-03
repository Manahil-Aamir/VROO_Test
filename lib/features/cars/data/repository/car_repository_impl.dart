import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repository/car_repository.dart';
import '../data_source/car_data_source.dart';
import '../model/carr_model.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource apiDataSource;
  final FirebaseAuth firebaseAuth;

  CarRepositoryImpl({required this.apiDataSource, required this.firebaseAuth});

  // function to return token
  Future<String> getToken() async {
  final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        return token!;
      } catch (e) {
        throw Exception("Failed to get token: ${e.toString()}");
      }
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Future<List<Car>> getCars() async {
    return apiDataSource.fetchCarsFromApi(await getToken());
  }

  @override
  Future<void> addCar(Car car) async {
    return apiDataSource.addCarToApi(car, await getToken());
  }

  @override
  Future<void> deleteCar(String carId) async {
    return apiDataSource.deleteCarFromApi(carId, await getToken());
  }
}

