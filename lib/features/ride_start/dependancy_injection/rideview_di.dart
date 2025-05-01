import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/authentication/data/data_source/token_data_source.dart';
import 'package:vroo_test/features/ride_start/data/data_source/rider_view_datasource.dart';
import 'package:vroo_test/features/ride_start/data/repository/rideview_repository_impl.dart';
import 'package:vroo_test/features/ride_start/domain/repository/rideview_repository.dart';
import 'package:vroo_test/features/ride_start/domain/usecases/rider_view.dart';

import '../../authentication/data/repository/token_repository_impl.dart';
import '../../authentication/domain/usecases/get_token_usecase.dart';
import '../presentation/bloc/bloc/ride_view_bloc.dart';

class RideViewDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final getTokenUseCase = GetTokenUseCase(tokenRepository);

    final viewRideDataSource = RideViewRemoteDataSource(Client());
    final viewRideRepository = RideViewRepositoryImpl(viewRideDataSource);
    final viewRideUsecase = RiderViewUseCase(viewRideRepository);

    // Return the list of providers
    return [
      Provider<RideViewDataSource>(create: (_) => viewRideDataSource),
      Provider<RideViewRepository>(create: (_) => viewRideRepository),
      Provider<RiderViewUseCase>(create: (_) => viewRideUsecase),
      BlocProvider<RideViewBloc>(
          create: (_) => RideViewBloc(
                repository: viewRideUsecase,
                getTokenUseCase: getTokenUseCase,
              )),
    ];
  }
}
