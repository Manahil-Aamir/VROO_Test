import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/HomeScreens/domain/usecase/review_usecase.dart';
import '../../authentication/data/data_source/token_data_source.dart';
import '../../authentication/data/repository/token_repository_impl.dart';
import '../../authentication/domain/usecases/get_token_usecase.dart';
import '../data/data_source/home_data_source.dart';
import '../data/repository/home_repository_impl.dart';
import '../domain/repository/home_repository.dart';
import '../domain/usecase/get_current_location.dart';
import '../domain/usecase/clear_preferences_usecase.dart';
import '../domain/usecase/get_user_usecase.dart';
import '../domain/usecase/logout_usecase.dart';
import '../domain/usecase/ongoing_usecase.dart';
import '../presentation/bloc/bloc/home_bloc.dart';

class HomeDependencyInjection {
  static List<SingleChildWidget> init() {
    final http.Client client =
        http.Client(); // Replace with your actual HTTP client
    final dataSource = HomeDataSourceImpl(client);
    final repository = HomeRepositoryImpl(dataSource);

    final firebaseAuth = FirebaseAuth.instance;
    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final getTokenUseCase = GetTokenUseCase(tokenRepository);

    return [
      BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(
          getCurrentLocation: GetCurrentLocation(repository),
          clearPreferences: ClearPreferencesUseCase(repository),
          getUser: GetUserUseCase(repository),
          logout: LogoutUseCase(repository),
          checkOngoingTrip: OngoingUsecase(repository),
          getTokenUseCase: GetTokenUseCase(tokenRepository),
          reviewUseCase: ReviewUseCase(repository),
        ),
      ),
      Provider<HomeRepository>(create: (_) => repository),
      Provider<HomeDataSource>(create: (_) => dataSource),
    ];
  }
}
