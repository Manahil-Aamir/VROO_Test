import '../entity/chat_user.dart';
import '../repository/chat_repository.dart';

class GetChatUsersUseCase {
  final ChatRepository repository;

  GetChatUsersUseCase(this.repository);

  Future<List<ChatUser>> call(String role) {
    return repository.getChatUsers(role);
  }
}

