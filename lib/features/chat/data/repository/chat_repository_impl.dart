import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/chat_user.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_source/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseAuth firebaseAuth;
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource, this.firebaseAuth);

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
}
