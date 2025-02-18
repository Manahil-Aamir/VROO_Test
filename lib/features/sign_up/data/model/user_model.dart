import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.gender,
    required super.phoneNumber,
    required super.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'name': name,
      };
}
