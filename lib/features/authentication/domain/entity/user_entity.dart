// domain/entities/profile_entity.dart
class UserEntity {
  final String id;
  final String gender;
  final String phoneNumber;
  final String name;
  final String email;

  UserEntity(
      {required this.id,
      required this.gender,
      required this.phoneNumber,
      required this.name,
      required this.email
  });
}
