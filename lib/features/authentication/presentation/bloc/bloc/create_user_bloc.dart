import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_user_usecase.dart';
import '../../../domain/usecases/get_token_usecase.dart';
import '../event/create_user_event.dart';
import '../state/create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final CreateUserUseCase createUser;
  final GetTokenUseCase getToken;

  CreateUserBloc({required this.createUser, required this.getToken})
      : super(CreateUserInitial()) {
    on<CreateUserSubmitted>(_onCreateUserSubmitted);
  }

  Future<void> _onCreateUserSubmitted(
      CreateUserSubmitted event, Emitter<CreateUserState> emit) async {
    emit(CreateUserLoading());

    try {
      // Fetch token
      final token = await getToken();
      if (token == null) {
        emit(CreateUserFailure("Failed to retrieve authentication token."));
        return;
      }

      // Create user
      final response = await createUser(event.user, token);

      final success = response['success'] ?? false;
      final message = response['message'] ?? 'User created successfully';

      if (success) {
        emit(CreateUserSuccess());
      } else {
        // emit(CreateUserSuccess());
        emit(CreateUserFailure(message));
      }
    } catch (e) {
      // emit(CreateUserSuccess());
      emit(CreateUserFailure(e.toString()));
    }
  }
}
