// injection.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/create_user_data_source.dart';
import '../data/data_source/phone_verification_data_source.dart';
import '../data/repository/phone_verification_repository_impl.dart';
import '../data/repository/user_repository_impl.dart';
import '../domain/repository/phone_verification_repository.dart';
import '../domain/repository/user_repository.dart';
import '../domain/usecases/create_user_usecase.dart';
import '../domain/usecases/phone_verify_usecases.dart';
import '../presentation/bloc/bloc/create_user_bloc.dart';
import '../presentation/bloc/bloc/phone_verification_bloc.dart';

class CreateUserDependencies {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();

    final phoneDataSource = FirebasePhoneVerificationDataSource(firebaseAuth);
    final phoneRepo = PhoneVerificationRepositoryImpl(phoneDataSource);
    
    final userDataSource = ApiUserRemoteDataSource(client);
    final userRepo = UserRepositoryImpl(userDataSource);

    return [
      // Data Sources
      Provider<PhoneVerificationRemoteDataSource>(create: (_) => phoneDataSource),
      Provider<UserRemoteDataSource>(create: (_) => userDataSource),

      // Repositories
      Provider<PhoneVerificationRepository>(create: (_) => phoneRepo),
      Provider<UserRepository>(create: (_) => userRepo),

      // Use Cases
      Provider<SendOtpUseCase>(create: (_) => SendOtpUseCase(phoneRepo)),
      Provider<VerifyOtpUseCase>(create: (_) => VerifyOtpUseCase(phoneRepo)),
      Provider<CreateUserUseCase>(create: (_) => CreateUserUseCase(userRepo)),

      // BLoCs
      BlocProvider<PhoneVerificationBloc>(
        create: (context) => PhoneVerificationBloc(
          sendOtp: context.read<SendOtpUseCase>(),
          verifyOtp: context.read<VerifyOtpUseCase>(),
        ),
      ),
      BlocProvider<CreateUserBloc>(
        create: (context) => CreateUserBloc(
          createUser: context.read<CreateUserUseCase>(),
        ),
      ),
    ];
  }
}