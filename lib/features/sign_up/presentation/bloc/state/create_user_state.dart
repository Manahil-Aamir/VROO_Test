sealed class CreateUserState {}

final class CreateUserInitial extends CreateUserState {}

final class CreateUserLoading extends CreateUserState {}

final class CreateUserSuccess extends CreateUserState {}

final class CreateUserFailure extends CreateUserState {
  final String error;

  CreateUserFailure(this.error);
}