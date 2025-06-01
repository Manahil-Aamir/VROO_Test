class UserProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String gender;
  final double ratingsAsDriver;
  final double ratingsAsRider;
  final double co2Saved;
  final double fuelSaved;
  final int totalRidesAsDriver;
  final int totalRidesAsRider;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.ratingsAsDriver,
    required this.ratingsAsRider,
    required this.co2Saved,
    required this.fuelSaved,
    required this.totalRidesAsDriver,
    required this.totalRidesAsRider,
  });

  toJson() {}
}
