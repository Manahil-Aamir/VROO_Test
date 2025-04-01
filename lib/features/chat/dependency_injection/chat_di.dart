import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import 'package:vroo_test/features/chat/data/data_source/chat_firestore_data_source.dart';

import '../data/data_source/chat_remote_datasource.dart';
import '../data/repository/chat_repository_impl.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/usecases/get_chat_fcm_tokens.dart';
import '../domain/usecases/get_messages_usecase.dart';
import '../domain/usecases/messages_usecases.dart';
import '../domain/usecases/send_message_usecase.dart';
import '../presentation/bloc/bloc/chat_bloc.dart';

class ChatDependencyInjection {
  static List<SingleChildWidget> init() {
    final client = http.Client();
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final chatFirestoreDataSource = ChatFirestoreDataSourceImpl(firestore);
    final chatRemoteDataSource = ChatRemoteDataSourceImpl(client);
    final chatRepository = ChatRepositoryImpl(chatRemoteDataSource, firebaseAuth, chatFirestoreDataSource);
    final getChatUsersUseCase = GetChatUsersUseCase(chatRepository);
    final sendMessageUseCase = SendMessageUseCase(chatRepository);
    final getMessagesUseCase = GetMessagesUseCase(chatRepository);
    final getChatInfoUseCase = GetChatInfoUseCase(chatRepository);
    final streamLastMessageInfoUseCase = StreamLastMessageInfoUseCase(chatRepository);

    return [
      Provider<ChatFirestoreDataSource>(create: (_) => chatFirestoreDataSource),
      Provider<ChatRemoteDataSource>(create: (_) => chatRemoteDataSource),
      Provider<ChatRepository>(create: (_) => chatRepository),
      Provider<GetChatUsersUseCase>(create: (_) => getChatUsersUseCase),
      Provider<SendMessageUseCase>(create: (_) => sendMessageUseCase),
      Provider<GetMessagesUseCase>(create: (_) => getMessagesUseCase),
      Provider<GetChatInfoUseCase>(create: (_) => getChatInfoUseCase),
      Provider<StreamLastMessageInfoUseCase>(create: (_) => streamLastMessageInfoUseCase),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          getChatUsers: getChatUsersUseCase, 
          sendMessage: sendMessageUseCase, 
          getMessages: getMessagesUseCase,
          getChatInfo: getChatInfoUseCase,
          firestoreDataSource: chatFirestoreDataSource,
          streamLastMessageInfo: streamLastMessageInfoUseCase,  
        ),
      ),
    ];
  }
}
