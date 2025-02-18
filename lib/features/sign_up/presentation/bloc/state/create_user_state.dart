import 'package:equatable/equatable.dart';

sealed class CreateUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CreateUserInitial extends CreateUserState {}

final class CreateUserLoading extends CreateUserState {}

final class CreateUserSuccess extends CreateUserState {}

final class CreateUserFailure extends CreateUserState {
  final String error;

  CreateUserFailure(this.error);

  @override
  List<Object?> get props => [error];
}
