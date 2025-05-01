import 'package:vroo_test/features/HomeScreens/data/models/ongoing_model.dart';

import '../repository/home_repository.dart';

class OngoingUsecase {
  final HomeRepository repository;

  OngoingUsecase(this.repository);

  Future<OngoingModel> call(String token) async {
    return await repository.ongoing(token);
  }
}
