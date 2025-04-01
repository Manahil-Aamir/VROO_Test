import '../repository/chat_repository.dart';

class GetChatInfoUseCase {
  final ChatRepository repository;

  GetChatInfoUseCase(this.repository);

  Future<Map<String, dynamic>?> call(String chatId) {
    return repository.getChatInfo(chatId);
  }
}

class StreamLastMessageInfoUseCase {
  final ChatRepository repository;

  StreamLastMessageInfoUseCase(this.repository);

  Stream<Map<String, dynamic>?> call(String chatId) {
    return repository.streamLastMessageInfo(chatId);
  }
}
