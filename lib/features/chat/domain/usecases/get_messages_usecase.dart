import '../entity/chat_message.dart';
import '../repository/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String chatId, [int limit = 20]) {
    return repository.getMessages(chatId, limit);
  }
}
