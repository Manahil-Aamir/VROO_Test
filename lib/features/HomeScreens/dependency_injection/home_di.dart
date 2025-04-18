import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/data_source/home_data_source.dart';
import '../data/repository/home_repository_impl.dart';
import '../domain/repository/home_repository.dart';
import '../domain/usecase/get_current_location.dart';
import '../domain/usecase/clear_preferences_usecase.dart';
import '../domain/usecase/get_user_usecase.dart';
import '../domain/usecase/logout_usecase.dart';
import '../presentation/bloc/bloc/home_bloc.dart';

class HomeDependencyInjection {
  static List<SingleChildWidget> init() {
    final dataSource = HomeDataSourceImpl();
    final repository = HomeRepositoryImpl(dataSource);
    
    return [
      BlocProvider<HomeBloc>(
        create: (_) => HomeBloc(
          getCurrentLocation: GetCurrentLocation(repository),
          clearPreferences: ClearPreferencesUseCase(repository),
          getUser: GetUserUseCase(repository),
          logout: LogoutUseCase(repository),
        ),
      ),
      Provider<HomeRepository>(create: (_) => repository),
      Provider<HomeDataSource>(create: (_) => dataSource),
    ];
  }
}