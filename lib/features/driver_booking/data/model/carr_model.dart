import '../../domain/entity/car.dart';

class Car {
  final String company;
  final String model;
  final String color;
  final String numberPlate;
  final double mileage;
  final bool isVerified;

  Car({
    required this.company,
    required this.model,
    required this.color,
    required this.numberPlate,
    required this.mileage,
    required this.isVerified,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      company: json['company'] ?? 'Unknown', // Handle null
      model: json['model'] ?? 'Unknown',     // Handle null
      color: json['color'] ?? 'Unknown',     // Handle null
      numberPlate: json['number_plate'] ?? 'N/A', // Handle null
      mileage: json['mileage']?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'model': model,
      'color': color,
      'number_plate': numberPlate,
      'mileage': mileage,
      'isVerified': isVerified,
    };
  }

  // Add this conversion method
  CarEntity toEntity() => CarEntity(
        company: company,
        model: model,
        color: color,
        numberPlate: numberPlate,
        mileage: mileage,
        isVerified: isVerified,
      );
}