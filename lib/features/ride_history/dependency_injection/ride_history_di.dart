import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/data_source/ride_history_remote_data_source.dart';
import '../data/repository/ride_history_repository_impl.dart';
import '../domain/repository/ride_history_repository.dart';
import '../domain/usecases/get_driver_ride_history.dart';
import '../domain/usecases/get_rider_ride_history.dart';
import '../presentation/bloc/bloc/ride_history_bloc.dart';

class RideHistoryDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance;
    final client = http.Client();
    
    // Data sources
    final rideHistoryDataSource = RideHistoryRemoteDataSourceImpl(client: client);
    
    // Repositories
    final rideHistoryRepository = RideHistoryRepositoryImpl(
      remoteDataSource: rideHistoryDataSource,
      firebaseAuth: firebaseAuth,
    );
    
    // Use cases
    final getDriverHistory = GetDriverRideHistory(rideHistoryRepository);
    final getRiderHistory = GetRiderRideHistory(rideHistoryRepository);
    
    return [
      Provider<RideHistoryRemoteDataSource>(create: (_) => rideHistoryDataSource),
      Provider<RideHistoryRepository>(create: (_) => rideHistoryRepository),
      Provider<GetDriverRideHistory>(create: (_) => getDriverHistory),
      Provider<GetRiderRideHistory>(create: (_) => getRiderHistory),
      BlocProvider<RideHistoryBloc>(
        create: (_) => RideHistoryBloc(
          getDriverHistory: getDriverHistory,
          getRiderHistory: getRiderHistory,
        ),
      ),
    ];
  }
}
