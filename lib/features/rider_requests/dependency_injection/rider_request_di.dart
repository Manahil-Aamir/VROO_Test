import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

import '../data/data_source/rider_approved_request_remote_data_source.dart';
import '../data/data_source/rider_pending_request_remote_data_source.dart';
import '../data/repository/rider_approved_request_repository_impl.dart';
import '../data/repository/rider_pending_request_repository_impl.dart';
import '../domain/repository/rider_approved_request_repository.dart';
import '../domain/repository/rider_pending_request_repository.dart';
import '../domain/usecases/get_approved_ride_requests.dart';
import '../domain/usecases/get_pending_ride_requests.dart';
import '../presentation/bloc/bloc/rider_approved_requests_bloc.dart';
import '../presentation/bloc/bloc/rider_pending_requests_bloc.dart';

class RiderRequestsDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final firebaseAuth = FirebaseAuth.instance; 

    // Data sources
    final pendingDataSource = RiderPendingRequestDataSourceImpl(client: httpClient);
    final approvedDataSource = RiderApprovedRequestDataSourceImpl(client: httpClient);

    // Repositories
    final pendingRepository = RiderPendingRequestRepositoryImpl(pendingDataSource, firebaseAuth);
    final approvedRepository = RiderApprovedRequestRepositoryImpl(approvedDataSource, firebaseAuth);

    // Use cases
    final getPendingRequestsUseCase = GetPendingRequestsUseCase(pendingRepository);
    final getApprovedRequestsUseCase = GetApprovedRequestsUseCase(approvedRepository);

    return [
      Provider<http.Client>(create: (_) => httpClient),
      Provider<RiderPendingRequestDataSource>(create: (_) => pendingDataSource),
      Provider<RiderApprovedRequestDataSource>(create: (_) => approvedDataSource),
      Provider<RiderPendingRequestRepository>(create: (_) => pendingRepository),
      Provider<RiderApprovedRequestRepository>(create: (_) => approvedRepository),
      Provider<GetPendingRequestsUseCase>(create: (_) => getPendingRequestsUseCase),
      Provider<GetApprovedRequestsUseCase>(create: (_) => getApprovedRequestsUseCase),
      BlocProvider<RiderPendingRequestBloc>(
        create: (_) => RiderPendingRequestBloc(getPendingRequestsUseCase: getPendingRequestsUseCase),
      ),
      BlocProvider<RiderApprovedRequestBloc>(
        create: (_) => RiderApprovedRequestBloc(getApprovedRequestsUseCase: getApprovedRequestsUseCase),
      ),
    ];
  }
}
