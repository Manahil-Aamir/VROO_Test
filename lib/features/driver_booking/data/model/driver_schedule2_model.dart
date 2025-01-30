class CarPreferencesModel {
  final String? selectedCar;
  final int availableSeats;
  final bool sameGenderOnly;

  CarPreferencesModel({
    this.selectedCar,
    required this.availableSeats,
    required this.sameGenderOnly,
  });

  // Factory constructor to create a model from a JSON map (for API or local storage)
  factory CarPreferencesModel.fromJson(Map<String, dynamic> json) {
    return CarPreferencesModel(
      selectedCar: json['selectedCar'],
      availableSeats: json['availableSeats'] ?? 2,
      sameGenderOnly: json['sameGenderOnly'] ?? false,
    );
  }

  // Method to convert model to a map (for storage or API request)
  Map<String, dynamic> toJson() {
    return {
      'selectedCar': selectedCar,
      'availableSeats': availableSeats,
      'sameGenderOnly': sameGenderOnly,
    };
  }
}
