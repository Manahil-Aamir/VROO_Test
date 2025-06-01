import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/data_source/auth_remote_data_source.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecases/auth_usecases.dart';
import '../presentation/bloc/bloc/auth_bloc.dart';
import '../presentation/bloc/bloc/email_verification_bloc.dart';

class AuthDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final authDataSource = FirebaseAuthDataSource(firebaseAuth);
    final authRepository = AuthRepositoryImpl(authDataSource);

    return [
      Provider<AuthRemoteDataSource>(create: (_) => authDataSource),
      Provider<AuthRepository>(create: (_) => authRepository),
      Provider<SignUpUseCase>(create: (_) => SignUpUseCase(authRepository)),
      Provider<SendEmailVerificationUseCase>(
          create: (_) => SendEmailVerificationUseCase(authRepository)),
      Provider<CheckEmailVerificationUseCase>(
          create: (_) => CheckEmailVerificationUseCase(authRepository)),
      Provider<DeleteUserUseCase>(
          create: (_) => DeleteUserUseCase(authRepository)),
      BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(
              signUpUseCase: SignUpUseCase(authRepository),
              sendEmailVerificationUseCase:
                  SendEmailVerificationUseCase(authRepository))),
      BlocProvider<EmailVerificationBloc>(
        create: (context) => EmailVerificationBloc(
          checkEmailVerification: context.read<CheckEmailVerificationUseCase>(),
          sendEmailVerification: context.read<SendEmailVerificationUseCase>(),
          deleteUserUseCase: context.read<DeleteUserUseCase>(),
        ),
      ),
    ];
  }
}
