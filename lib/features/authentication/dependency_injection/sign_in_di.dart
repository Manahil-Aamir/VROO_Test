import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/authentication/data/data_source/sign_in_data_source.dart';
import 'package:vroo_test/features/authentication/data/repository/sign_in_repository_impl.dart';
import 'package:vroo_test/features/authentication/domain/repository/sign_in_repository.dart';
import 'package:vroo_test/features/authentication/presentation/bloc/bloc/sign_in_bloc.dart';

import '../domain/usecases/forget_password_usecase.dart';
import '../domain/usecases/login_usecase.dart';

class SignInDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();
    // Data Source
    final authDataSource = SignInDataSourceImpl(firebaseAuth: firebaseAuth);

    // Repository
    final authRepository = SignInRepositoryImpl(dataSource: authDataSource);

    // Use Cases
    final loginUseCase = LoginUseCase(repository: authRepository);
    final forgotPasswordUseCase =
        ForgotPasswordUseCase(repository: authRepository);

    // Provide them
    return [
      Provider<SignInDataSource>(create: (_) => authDataSource),
      Provider<SignInRepository>(create: (_) => authRepository),
      Provider<LoginUseCase>(create: (_) => loginUseCase),
      Provider<ForgotPasswordUseCase>(create: (_) => forgotPasswordUseCase),
      BlocProvider<SignInBloc>(
        create: (_) => SignInBloc(
          loginUseCase: loginUseCase,
          forgotPasswordUseCase: forgotPasswordUseCase,
        ),
      ),
    ];
  }
}
