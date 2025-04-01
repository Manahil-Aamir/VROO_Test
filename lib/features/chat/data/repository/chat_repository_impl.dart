import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/chat_message.dart';
import '../../domain/entity/chat_user.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_source/chat_firestore_data_source.dart';
import '../data_source/chat_remote_datasource.dart';
import '../model/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseAuth firebaseAuth;
  final ChatRemoteDataSource remoteDataSource;
  final ChatFirestoreDataSource firestoreDataSource;

  ChatRepositoryImpl(this.remoteDataSource, this.firebaseAuth, this.firestoreDataSource);

  @override
  Future<void> sendMessage(ChatMessage message) {
    return firestoreDataSource.sendMessage(ChatMessageModel(
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
    ));
  }

  @override
  Stream<List<ChatMessage>> getMessages(String chatId, [int limit = 20]) {
    return firestoreDataSource.getMessages(chatId, limit).map((messages) => messages
        .map((message) => ChatMessage(
              senderId: message.senderId,
              receiverId: message.receiverId,
              message: message.message,
              timestamp: message.timestamp,
            ))
        .toList());
  }

  @override
  Future<Map<String, dynamic>?> getChatInfo(String chatId) {
    return firestoreDataSource.getChatInfo(chatId);
  }

  @override
  Future<List<ChatUser>> getChatUsers(String role) async {
    final current_user = firebaseAuth.currentUser;
    if (current_user == null) {
      throw Exception("User not found after login");
    }

    // Get ID token
    final token = await current_user.getIdToken();

    final users = await remoteDataSource.getChatUsers(role, token!);
    return users
        .map((user) => ChatUser(
              id: user.id,
              name: user.name,
              fcmToken: user.fcmToken,
              source: user.source,
              destination: user.destination,
            ))
        .toList();
  }

  Stream<Map<String, dynamic>?> streamLastMessageInfo(String chatId) {
    return firestoreDataSource.streamLastMessageInfo(chatId);
  }
}
