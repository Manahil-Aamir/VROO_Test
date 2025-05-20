import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/ride_start/data/data_source/start_ride_datasource.dart';
import 'package:vroo_test/features/ride_start/domain/repository/ridestart_repository.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/bloc/ridestart_bloc.dart';

import '../../authentication/data/data_source/token_data_source.dart';
import '../../authentication/data/repository/token_repository_impl.dart';
import '../../authentication/domain/usecases/get_token_usecase.dart';
import '../data/repository/ridestart_repository_impl.dart';
import '../domain/usecases/give_review.dart';
import '../domain/usecases/start_ride.dart';

class RideStartDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final getTokenUseCase = GetTokenUseCase(tokenRepository);

    final startRideDataSource = StartRideRemoteDataSource(Client());
    final startRideRepository = StartRideRepositoryImpl(startRideDataSource);
    final startRideUsecase = StartRide(startRideRepository);
    final giveReviewUsecase = GiveReview(startRideRepository);

    // Return the list of providers
    return [
      Provider<StartRideDataSource>(create: (_) => startRideDataSource),
      Provider<StartRideRepository>(create: (_) => startRideRepository),
      Provider<StartRide>(create: (_) => startRideUsecase),
      BlocProvider<RideStartBloc>(
          create: (_) => RideStartBloc(
                repository: startRideUsecase,
                getTokenUseCase: getTokenUseCase,
                giveReviewUseCase: giveReviewUsecase,
              )),
    ];
  }
}
