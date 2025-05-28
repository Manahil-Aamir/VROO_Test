import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
import '../model/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthUser> signUpWithEmailAndPassword(
      String email, String password) async {
    final user =
        await remoteDataSource.signUpWithEmailAndPassword(email, password);
    return AuthModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Future<void> deleteUser() => remoteDataSource.deleteUser();

  @override
  Future<void> sendEmailVerification() =>
      remoteDataSource.sendEmailVerification();

  @override
  Future<bool> checkEmailVerification() async {
    final useremailverified = await remoteDataSource.checkEmailVerification();
    return useremailverified;
  }

  @override
  Future<void> resendVerificationEmail() => sendEmailVerification();
}

extension AuthModelExtensions on AuthModel {
  AuthUser toEntity() =>
      AuthUser(email: email, isEmailVerified: isEmailVerified);
}
