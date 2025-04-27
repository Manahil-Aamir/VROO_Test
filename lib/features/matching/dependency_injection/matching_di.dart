import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/matching_data_source.dart';
import '../data/repository/matching_repository_impl.dart';
import '../domain/repository/matching_repository.dart';
import '../domain/usecase/get_ride_request_matches_usecase.dart';
import '../domain/usecase/modify_ride_usecase.dart';
import '../domain/usecase/send_join_request_usecase.dart';
import '../presentation/bloc/bloc/matching_bloc.dart';

class MatchingDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the MatchingDataSource, MatchingRepository, and UseCase
    final firebaseAuth = FirebaseAuth.instance; 
    final matchingDataSource = MatchingDataSourceImpl(client: Client());
    final matchingRepository = MatchingRepositoryImpl(matchingDataSource, firebaseAuth);
    final modifyRideUsecase = ModifyRideUseCase(matchingRepository);
    final sendRequestUsecase = SendJoinRequestUseCase(matchingRepository);
    final getRideRequestMatchesUseCase = GetRideRequestMatchesUseCase(matchingRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<MatchingDataSourceImpl>(create: (_) => matchingDataSource),
      Provider<MatchingRepository>(create: (_) => matchingRepository),
      Provider<ModifyRideUseCase>(create: (_) => modifyRideUsecase),
      Provider<SendJoinRequestUseCase>(create: (_) => sendRequestUsecase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<MatchingBloc>(
          create: (_) => MatchingBloc(modifyRideUsecase, sendRequestUsecase, getRideRequestMatchesUseCase)),
    ];
  }
}
