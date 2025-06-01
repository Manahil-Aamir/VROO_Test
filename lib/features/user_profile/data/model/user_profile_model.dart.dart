import '../../domain/entity/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.gender,
    required super.ratingsAsDriver,
    required super.ratingsAsRider,
    required super.co2Saved,
    required super.fuelSaved,
    required super.totalRidesAsDriver,
    required super.totalRidesAsRider,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      ratingsAsDriver: json['ratings']['asDriver'].toDouble(),
      ratingsAsRider: json['ratings']['asRider'].toDouble(),
      co2Saved: json['environmentStats']['CO2Saved'].toDouble(),
      fuelSaved: json['environmentStats']['fuelSaved'].toDouble(),
      totalRidesAsDriver: json['totalRides']['asDriver'],
      totalRidesAsRider: json['totalRides']['asRider'],
    );
  }
}
