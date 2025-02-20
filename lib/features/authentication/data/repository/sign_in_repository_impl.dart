import 'package:vroo_test/features/authentication/data/data_source/sign_in_data_source.dart';
import '../../domain/repository/sign_in_repository.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDataSource dataSource;

  SignInRepositoryImpl({required this.dataSource});

  @override
  Future<void> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<void> forgotPassword(String email) {
    return dataSource.forgotPassword(email);
  }
}
