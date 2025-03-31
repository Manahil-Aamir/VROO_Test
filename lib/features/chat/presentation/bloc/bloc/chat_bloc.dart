import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_chat_fcm_tokens.dart';
import '../event/chat_event.dart';
import '../state/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatUsersUseCase getChatUsers;

  ChatBloc({required this.getChatUsers}) : super(ChatInitial()) {
    on<LoadChatUsers>((event, emit) async {
      emit(ChatLoading());
      try {
        final users = await getChatUsers(event.role);
        emit(ChatLoaded(users));
      } catch (e) {
        emit(ChatError('Failed to load users'));
      }
    });
  }
}
