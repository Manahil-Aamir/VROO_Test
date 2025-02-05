import '../model/carr_model.dart';

class CarDataSource {
  Future<List<Car>> fetchCarsFromApi() async {
    // Replace with actual API logic
    return [
      Car(company: "Toyota", model: "Camry", color: "Red", numberPlate: "ABC123", mileage: 15000, isVerified: true),
      Car(company: "Honda", model: "Civic", color: "Blue", numberPlate: "XYZ456", mileage: 20000, isVerified: true),
      Car(company: "Ford", model: "Focus", color: "Black", numberPlate: "DEF789", mileage: 12000, isVerified: false),
    ];
  }

  Future<void> addCarToApi(Car car) async {
    // Add car to API logic
  }
}
