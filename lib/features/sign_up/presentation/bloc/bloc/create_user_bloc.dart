import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/create_user_usecase.dart';
import '../event/create_user_event.dart';
import '../state/create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final CreateUserUseCase createUser;

  CreateUserBloc({required this.createUser}) : super(CreateUserInitial()) {
    on<CreateUserSubmitted>(_onCreateUserSubmitted);
  }

  Future<void> _onCreateUserSubmitted(
      CreateUserSubmitted event, Emitter<CreateUserState> emit) async {
    emit(CreateUserLoading());
    try {
      await createUser(event.CreateUser);
      print('user created');
      emit(CreateUserSuccess());
    } catch (e) {
      emit(CreateUserFailure(e.toString()));
    }
  }
}
