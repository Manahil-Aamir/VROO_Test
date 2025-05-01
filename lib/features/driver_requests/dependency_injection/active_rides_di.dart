import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../../authentication/data/data_source/token_data_source.dart';
import '../../authentication/data/repository/token_repository_impl.dart';
import '../../authentication/domain/usecases/get_token_usecase.dart';
import '../data/data_source/active_rides_data_source.dart';
import '../data/repository/active_rides_repository_impl.dart';
import '../domain/repository/active_rides_repository.dart';
import '../domain/usecases/cancel_ride.dart';
import '../domain/usecases/get_active_rides.dart';
import '../domain/usecases/static_ride.dart';
import '../presentation/bloc/bloc/active_rides_bloc.dart';

class ActiveRideDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final firebaseAuth = FirebaseAuth.instance;
    final dataSource = ActiveRidesDriverRemoteDataSource(httpClient);
    final repository =
        ActiveRidesDriverRepositoryImpl(dataSource, firebaseAuth);
    final getActiveRidesDriver = GetActiveRidesDriver(repository);
    final getRideData = GetRideData(repository); // Initialize the new use case
    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final getTokenUseCase = GetTokenUseCase(tokenRepository);
    final cancelRide = CancelRide(repository);
    final navigationProvider = Navigation();

    return [
      Provider<ActiveRidesDriverDataSource>(create: (_) => dataSource),
      Provider<ActiveRidesDriverRepository>(create: (_) => repository),
      Provider<GetActiveRidesDriver>(create: (_) => getActiveRidesDriver),
      Provider<CancelRide>(create: (_) => cancelRide),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<ActiveRidesDriverBloc>(
        create: (_) => ActiveRidesDriverBloc(
          getActiveRidesDriver: getActiveRidesDriver,
          cancelRide: cancelRide,
          getRideData: getRideData,
          getTokenUseCase: getTokenUseCase,
        ),
      ),
    ];
  }
}
