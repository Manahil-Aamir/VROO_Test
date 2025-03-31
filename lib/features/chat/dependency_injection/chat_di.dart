import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import '../data/data_source/chat_remote_datasource.dart';
import '../data/repository/chat_repository_impl.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/usecases/get_chat_fcm_tokens.dart';
import '../presentation/bloc/bloc/chat_bloc.dart';

class ChatDependencyInjection {
  static List<SingleChildWidget> init() {
    final client = http.Client();
    final firebaseAuth = FirebaseAuth.instance;
    final chatDataSource = ChatRemoteDataSourceImpl(client);
    final chatRepository = ChatRepositoryImpl(chatDataSource, firebaseAuth);
    final getChatUsersUseCase = GetChatUsersUseCase(chatRepository);

    return [
      Provider<ChatRemoteDataSource>(create: (_) => chatDataSource),
      Provider<ChatRepository>(create: (_) => chatRepository),
      Provider<GetChatUsersUseCase>(create: (_) => getChatUsersUseCase),
      BlocProvider<ChatBloc>(
        create: (_) => ChatBloc(getChatUsers: getChatUsersUseCase),
      ),
    ];
  }
}
