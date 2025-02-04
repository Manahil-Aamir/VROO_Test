class CarPreferencesModel {
  final String? selectedCar;
  final int availableSeats;
  final bool sameGenderOnly;
  final String payment;

  CarPreferencesModel({
    this.selectedCar,
    required this.availableSeats,
    required this.sameGenderOnly,
    required this.payment,
  });

  // Factory constructor to create a model from a JSON map (for API or local storage)
  factory CarPreferencesModel.fromJson(Map<String, dynamic> json) {
    return CarPreferencesModel(
      selectedCar: json['selectedCar'],
      availableSeats: json['availableSeats'] ?? 2,
      sameGenderOnly: json['sameGenderOnly'] ?? false,
      payment: json['payment'] ?? 'Cash',
    );
  }

  // Method to convert model to a map (for storage or API request)
  Map<String, dynamic> toJson() {
    return {
      'selectedCar': selectedCar,
      'availableSeats': availableSeats,
      'sameGenderOnly': sameGenderOnly,
      'payment': payment,
    };
  }
}
