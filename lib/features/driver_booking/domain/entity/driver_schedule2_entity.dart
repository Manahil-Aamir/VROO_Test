class CarPreferencesEntity {
  String? selectedCar;
  int availableSeats;
  bool sameGenderOnly;
  String payment; 

  CarPreferencesEntity({
    this.selectedCar,
    required this.availableSeats,
    required this.sameGenderOnly,
    required this.payment,
  });

  Map<String, dynamic> toMap() {
    return {
      'selectedCar': selectedCar,
      'availableSeats': availableSeats,
      'sameGenderOnly': sameGenderOnly,
      'payment': payment,
    };
  }

  factory CarPreferencesEntity.fromMap(Map<String, dynamic> map) {
    return CarPreferencesEntity(
      selectedCar: map['selectedCar'],
      availableSeats: map['availableSeats'] ?? 2,
      sameGenderOnly: map['sameGenderOnly'] ?? false,
      payment: map['payment'] ?? 'Cash',
    );
  }
}