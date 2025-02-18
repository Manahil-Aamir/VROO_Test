// domain/entities/profile_entity.dart
class UserEntity {
  final int id;
  final String gender;
  final String phoneNumber;
  final String name;

  UserEntity(
      {required this.id,
      required this.gender,
      required this.phoneNumber,
      required this.name});
}
