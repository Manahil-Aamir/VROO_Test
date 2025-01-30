class Car {
  final String company;
  final String model;
  final String color;
  final String numberPlate;
  final double mileage;

  Car({
    required this.company,
    required this.model,
    required this.color,
    required this.numberPlate,
    required this.mileage,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      company: json['company'],
      model: json['model'],
      color: json['color'],
      numberPlate: json['numberPlate'],
      mileage: json['mileage'],
    );
  }
}