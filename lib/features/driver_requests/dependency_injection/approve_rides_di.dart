import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../data/data_source/approved_rides_data_source.dart';
import '../data/repository/approved_rides_repository_impl.dart';
import '../domain/repository/approved_rides_repository.dart';
import '../domain/usecases/get_approved_rides.dart';
import '../presentation/bloc/bloc/approved_rides_bloc.dart';

class ApproveRidesDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final firebaseAuth = FirebaseAuth.instance; 
    final dataSource = ApprovedRidesRemoteDataSource(httpClient);
    final repository = ApprovedRidesRepositoryImpl(dataSource, firebaseAuth);
    final getApprovedRides = GetApprovedRides(repository);
    final navigationProvider = Navigation();

    return [
      Provider<ApprovedRidesDataSource>(create: (_) => dataSource),
      Provider<ApprovedRidesRepository>(create: (_) => repository),
      Provider<GetApprovedRides>(create: (_) => getApprovedRides),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<ApprovedRidesBloc>(
        create: (_) => ApprovedRidesBloc(
          getApprovedRides: getApprovedRides,
        ),  
      ),
    ];
  }
}
