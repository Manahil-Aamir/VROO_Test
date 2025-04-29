import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import '../data/data_source/ride_request_join_remote_datasource.dart';
import '../data/repository/ride_request_join_repository_impl.dart';
import '../domain/repository/ride_request_join_repository.dart';
import '../domain/usecases/cancel_join_request_usecase.dart';
import '../domain/usecases/get_ride_request_joins.dart';
import '../presentation/bloc/bloc/ride_request_join_bloc.dart';

class RideRequestJoinDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final firebaseAuth = FirebaseAuth.instance; 

    // Data source
    final remoteDataSource = RideRequestJoinRemoteDatasourceImpl(httpClient);

    // Repository
    final repository = RideRequestJoinRepositoryImpl(remoteDataSource, firebaseAuth);

    // Use case
    final getPendingRideRequestJoinsUsecase = GetPendingRideRequestJoinsUsecase(repository);
    final cancelJoinRequestUsecase = CancelJoinRequestUsecase(repository);

    return [
      Provider<http.Client>(create: (_) => httpClient),
      Provider<RideRequestJoinRemoteDatasource>(create: (_) => remoteDataSource),
      Provider<RideRequestJoinRepository>(create: (_) => repository),
      Provider<GetPendingRideRequestJoinsUsecase>(create: (_) => getPendingRideRequestJoinsUsecase),
      Provider<CancelJoinRequestUsecase>(create: (_) => cancelJoinRequestUsecase),
      BlocProvider<RideRequestJoinBloc>(
        create: (_) => RideRequestJoinBloc(getPendingRideRequestJoinsUsecase, cancelJoinRequestUsecase),
      ),
    ];
  }
}
