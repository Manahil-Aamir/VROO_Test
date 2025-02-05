import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;
import '../../../core/router/navigation.dart';
import '../data/data_source/rides_details_data_source.dart';
import '../data/repository/rides_details_repository_impl.dart';
import '../domain/repository/rides_details_repository.dart';
import '../domain/usecases/get_rides_details.dart';
import '../presentation/bloc/bloc/rides_details_bloc.dart';

class RidesDetailsDi {
  static List<SingleChildWidget> init() {
    final httpClient = http.Client();
    final dataSource = RideDetailsRemoteDataSource(httpClient);
    final repository = RideDetailsRepositoryImpl(dataSource);
    final getRideDetails = GetRideDetails(repository);
    final navigationProvider = Navigation();

    return [
      Provider<RideDetailsDataSource>(create: (_) => dataSource),
      Provider<RideDetailsRepository>(create: (_) => repository),
      Provider<GetRideDetails>(create: (_) => getRideDetails),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<RideDetailsBloc>(
        create: (_) => RideDetailsBloc(getRideDetails),
      ),
    ];
  }
}
