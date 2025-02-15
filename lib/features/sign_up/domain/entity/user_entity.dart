// domain/entities/profile_entity.dart
class UserEntity {
  final String email;
  final String gender;
  final String phoneNumber;
  final String first_name;
  final String last_name;

  UserEntity({
    required this.email,
    required this.gender,
    required this.phoneNumber,
    required this.first_name,
    required this.last_name,
  });
}
