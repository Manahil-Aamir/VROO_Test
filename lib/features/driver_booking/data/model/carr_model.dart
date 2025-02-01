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
      company: json['company'],
      model: json['model'],
      color: json['color'],
      numberPlate: json['numberPlate'],
      mileage: json['mileage'],
      isVerified: json['isVerified'],
    );
  }
}