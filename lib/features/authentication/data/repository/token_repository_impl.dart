import '../../domain/repository/token_repository.dart';
import '../data_source/token_data_source.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenRemoteDataSource remoteDataSource;

  TokenRepositoryImpl(this.remoteDataSource);

  @override
  Future<String?> getToken() {
    return remoteDataSource.fetchToken();
  }
}
