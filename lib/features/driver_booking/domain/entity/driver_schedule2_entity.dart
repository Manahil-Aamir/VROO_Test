class CarPreferencesEntity {
  String? selectedCar;
  int availableSeats;
  bool sameGenderOnly;

  CarPreferencesEntity({
    this.selectedCar,
    required this.availableSeats,
    required this.sameGenderOnly,
  });

  Map<String, dynamic> toMap() {
    return {
      'selectedCar': selectedCar,
      'availableSeats': availableSeats,
      'sameGenderOnly': sameGenderOnly,
    };
  }

  factory CarPreferencesEntity.fromMap(Map<String, dynamic> map) {
    return CarPreferencesEntity(
      selectedCar: map['selectedCar'],
      availableSeats: map['availableSeats'] ?? 2,
      sameGenderOnly: map['sameGenderOnly'] ?? false,
    );
  }
}