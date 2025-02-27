import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.gender,
    required super.phoneNumber,
    required super.name,
    required super.email,
  });

  Map<String, dynamic> toJson() => {
        'uid': id,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'name': name,
        'email': email,
      };
}
