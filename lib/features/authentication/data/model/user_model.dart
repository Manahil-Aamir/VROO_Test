import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.gender,
    required super.phoneNumber,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'name': name,
        'email': email,
      };
}
