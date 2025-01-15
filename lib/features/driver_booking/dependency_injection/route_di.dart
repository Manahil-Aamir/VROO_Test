import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/route_data_source.dart';
import '../data/repository/route_repository_impl.dart';
import '../domain/repository/route_repository.dart';
import '../domain/usecases/fetch_routes.dart';
import '../presentation/bloc/bloc/route_bloc.dart';
import '../presentation/bloc/bloc/route_map_bloc.dart';

class RouteDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the data source, repository, and use cases
    final routeDataSource = RouteDataSource(http.Client());
    final routeRepository = RouteRepositoryImpl(routeDataSource);
    final fetchRoutesUseCase = FetchRoutesUseCase(routeRepository);

    // Return the list of providers
    return [
      Provider<RouteDataSource>(create: (_) => routeDataSource),
      Provider<RouteRepository>(create: (_) => routeRepository),
      Provider<FetchRoutesUseCase>(create: (_) => fetchRoutesUseCase),
      Provider<Navigation>(create: (_) => Navigation()), // Add Navigation provider
      BlocProvider<RouteBloc>(
        create: (_) => RouteBloc(fetchRoutesUseCase: fetchRoutesUseCase),
      ),
      BlocProvider<MapBloc>(
        create: (_) => MapBloc()
      ),
    ];
  }
}
