import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../data/data_source/active_rides_data_source.dart';
import '../data/repository/active_rides_repository_impl.dart';
import '../domain/repository/active_rides_repository.dart';
import '../domain/usecases/get_active_rides.dart';
import '../presentation/bloc/bloc/active_rides_bloc.dart';

class ActiveRideDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final dataSource = ActiveRidesRemoteDataSource(httpClient);
    final repository = ActiveRidesRepositoryImpl(dataSource);
    final getActiveRides = GetActiveRides(repository);

    return [
      Provider<ActiveRidesDataSource>(create: (_) => dataSource),
      Provider<ActiveRidesRepository>(create: (_) => repository),
      Provider<GetActiveRides>(create: (_) => getActiveRides),
      BlocProvider<ActiveRidesBloc>(
        create: (_) => ActiveRidesBloc(getActiveRides),
      ),
    ];
  }
}