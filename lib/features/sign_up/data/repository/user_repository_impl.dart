import 'package:vroo_test/features/sign_up/data/model/user_model.dart';
import 'package:vroo_test/features/sign_up/domain/entity/user_entity.dart';
import 'package:vroo_test/features/sign_up/domain/repository/user_repository.dart';

import '../data_source/create_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createUser(UserEntity profile) async {
    await remoteDataSource.createUser(UserModel(
      email: profile.email,
      gender: profile.gender,
      phoneNumber: profile.phoneNumber,
    ));
  }
}