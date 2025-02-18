import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import '../data/data_source/create_user_data_source.dart';
import '../data/data_source/token_data_source.dart';
import '../data/repository/token_repository_impl.dart';
import '../data/repository/user_repository_impl.dart';
import '../domain/repository/token_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/usecases/create_user_usecase.dart';
import '../domain/usecases/get_token_usecase.dart';
import '../presentation/bloc/bloc/create_user_bloc.dart';

class CreateUserDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();

    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final userDataSource = UserRemoteDataSourceImpl(client);

    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final userRepository = UserRepositoryImpl(userDataSource);

    final getTokenUseCase = GetTokenUseCase(tokenRepository);
    final createUserUseCase = CreateUserUseCase(userRepository);

    return [
      Provider<TokenRemoteDataSource>(create: (_) => tokenDataSource),
      Provider<UserRemoteDataSource>(create: (_) => userDataSource),
      Provider<TokenRepository>(create: (_) => tokenRepository),
      Provider<UserRepository>(create: (_) => userRepository),
      Provider<GetTokenUseCase>(create: (_) => getTokenUseCase),
      Provider<CreateUserUseCase>(create: (_) => createUserUseCase),
      BlocProvider<CreateUserBloc>(
        create: (_) => CreateUserBloc(
            createUser: createUserUseCase, getToken: getTokenUseCase),
      ),
    ];
  }
}
