import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../data/data_source/ride_request_data_source.dart';
import '../data/repository/ride_repository_impl.dart';
import '../domain/repository/ride_request_repository.dart';
import '../domain/usecases/submit_ride_request.dart';
import '../presentation/bloc/bloc/d3_bloc.dart';

class D3DependencyInjection {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final remoteDataSource = RideRemoteDataSourceImpl(httpClient);
    final repository = RideRepositoryImpl(remoteDataSource);
    final submitRideRequest = SubmitRideRequest(repository);
    final navigationProvider = Navigation();


    return [
      Provider<RideRemoteDataSource>(create: (_) => remoteDataSource),
      Provider<RideRepository>(create: (_) => repository),
      Provider<SubmitRideRequest>(create: (_) => submitRideRequest),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<RideBloc>(create: (_) => RideBloc(submitRideRequest)),
    ];
  }
}
