import '../repository/token_repository.dart';

class GetTokenUseCase {
  final TokenRepository repository;

  GetTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.getToken();
  }
}
