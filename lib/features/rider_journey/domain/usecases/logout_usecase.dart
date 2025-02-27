import '../repository/rider_home_repository.dart';

class Logout {
  final RiderHomeRepository repository;

  Logout(this.repository);

  Future<void> logout() {
    return repository.logout();
  }
}
