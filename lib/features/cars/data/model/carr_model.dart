import '../../domain/entity/car.dart';

class Car {
  final String carId;
  final String company;
  final String model;
  final String color;
  final String numberPlate;
  final double mileage;
  final bool isVerified;

  Car({
    required this.carId,
    required this.company,
    required this.model,
    required this.color,
    required this.numberPlate,
    required this.mileage,
    required this.isVerified,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['carId'] ?? json['_id'] ?? '',      
      company: json['company'] , 
      model: json['model'],     
      color: json['color'],     
      numberPlate: json['number_plate'] ?? json['numberPlate'] ?? '', // Handle both formats
      mileage: json['mileage']?.toDouble() ,
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': carId,
      'company': company,
      'model': model,
      'color': color,
      'numberPlate': numberPlate,
      'mileage': mileage,
      'isVerified': isVerified,
    };
  }

  // Add this conversion method
  CarEntity toEntity() => CarEntity(
        carId: carId,
        company: company,
        model: model,
        color: color,
        numberPlate: numberPlate,
        mileage: mileage,
        isVerified: isVerified,
      );
}