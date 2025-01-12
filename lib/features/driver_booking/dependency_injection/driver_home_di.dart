import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/driver_home_data_source.dart';
import '../data/repository/driver_home_repository.dart';
import '../domain/repository/driver_home_repository.dart';
import '../domain/usecases/get_driver_current_location.dart';
import '../presentation/bloc/driver_home_bloc.dart';

class DriverHomeDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the location repository and use case
    final locationRepository = DriverLocationRepositoryImpl(MockDriverLocationDataSource());
    final getDriverCurrentLocation = GetDriverCurrentLocation(locationRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<DriverLocationRepository>(create: (_) => locationRepository),
      Provider<GetDriverCurrentLocation>(create: (_) => getDriverCurrentLocation),
      //Provider<Navigation>(create: (_) => navigationProvider),
      Provider<Navigation>(create: (_) => Navigation()), // Add Navigation provider
      BlocProvider<DriverHomeBloc>(create: (_) => DriverHomeBloc(getDriverCurrentLocation)),
    ];
  }
}
