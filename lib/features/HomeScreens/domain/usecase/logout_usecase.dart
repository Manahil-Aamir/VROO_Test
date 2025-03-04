import '../repository/home_repository.dart';

class LogoutUseCase {
  final HomeRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() => repository.logout();
}