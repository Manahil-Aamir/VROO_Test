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
    final data = json['data']['userData'];
    return UserProfileModel(
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      gender: data['gender'],
      ratingsAsDriver: data['ratings']['asDriver'],
      ratingsAsRider: data['ratings']['asRider'],
      co2Saved: data['environmentStats']['CO2Saved'],
      fuelSaved: data['environmentStats']['fuelSaved'],
      totalRidesAsDriver: data['totalRides']['asDriver'],
      totalRidesAsRider: data['totalRides']['asRider'],
    );
  }
}
