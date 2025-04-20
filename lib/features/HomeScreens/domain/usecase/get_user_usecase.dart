import '../../../authentication/data/model/user_model.dart';
import '../repository/home_repository.dart';

class GetUserUseCase {
  final HomeRepository repository;

  GetUserUseCase(this.repository);

  Future<UserModel?> call() async {
    return await repository.getUser();
  }
}
