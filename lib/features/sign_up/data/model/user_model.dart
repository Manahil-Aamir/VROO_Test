class UserModel {
  final String email;
  final String gender;
  final String phoneNumber;

  UserModel({
    required this.email,
    required this.gender,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'gender': gender,
    'phoneNumber': phoneNumber,
  };
}