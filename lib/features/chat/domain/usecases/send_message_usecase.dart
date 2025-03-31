import '../entity/chat_message.dart';
import '../repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(ChatMessage message) {
    return repository.sendMessage(message);
  }
}
