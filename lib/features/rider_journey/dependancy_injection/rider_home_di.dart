import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/rider_home_bloc.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/rider_home_data_source.dart';
import '../data/repository/rider_home_data_repository.dart';
import '../domain/repository/rider_home_domain_repository.dart';
import '../domain/usecases/clear_preferences_usecase.dart';
import '../domain/usecases/rider_home_usecase.dart';

class RiderHomeDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the location repository and use case
    final locationRepository =
        RiderHomeRepositoryImpl(MockLocationDataSource());
    final getCurrentLocation = GetCurrentLocation(locationRepository);
    final navigationProvider = Navigation();
    final clearPreferencesUsecase = ClearPreferencesUseCase(locationRepository);

    // Return the list of providers
    return [
      Provider<RiderHomeRepository>(create: (_) => locationRepository),
      Provider<GetCurrentLocation>(create: (_) => getCurrentLocation),
      Provider<Navigation>(create: (_) => navigationProvider),
      Provider<ClearPreferencesUseCase>(create: (_) => clearPreferencesUsecase),
      BlocProvider<RiderHomeBloc>(
          create: (_) =>
              RiderHomeBloc(getCurrentLocation, clearPreferencesUsecase)),
    ];
  }
}
