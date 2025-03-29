import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../data/data_source/pending_rides_data_source.dart';
import '../data/repository/pending_rides_repository_impl.dart';
import '../domain/repository/pending_rides_repository.dart';
import '../domain/usecases/approve_ride_request.dart';
import '../domain/usecases/get_pending_rides.dart';
import '../domain/usecases/reject_ride_request.dart';
import '../presentation/bloc/bloc/pending_rides_bloc.dart';

class PendingRideDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final dataSource = PendingRidesRemoteDataSource(httpClient);
    final repository = PendingRidesRepositoryImpl(dataSource);
    final getPendingRides = GetPendingRides(repository);
    final approveRideRequest = ApproveRideRequest(repository);
    final rejectRideRequest = RejectRideRequest(repository);
    final navigationProvider = Navigation();

    return [
      Provider<PendingRidesDataSource>(create: (_) => dataSource),
      Provider<PendingRidesRepository>(create: (_) => repository),
      Provider<GetPendingRides>(create: (_) => getPendingRides),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<PendingRidesBloc>(
        create: (_) => PendingRidesBloc(
          getPendingRides: getPendingRides,
          approveRideRequest: approveRideRequest,
          rejectRideRequest: rejectRideRequest,
        ),  
      ),
    ];
  }
}
