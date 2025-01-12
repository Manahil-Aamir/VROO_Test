import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/home_bloc.dart';

import '../../../core/router/navigation.dart';
import '../data/data_source/home_data_source.dart';
import '../data/repository/home_data_repository.dart';
import '../domain/repository/home_domain_repository.dart';
import '../domain/usecases/home_usecase.dart';

class RiderHomeDependencyInjection {
  static List<SingleChildWidget> init() {
    // Set up the location repository and use case
    final locationRepository = LocationRepositoryImpl(MockLocationDataSource());
    final getCurrentLocation = GetCurrentLocation(locationRepository);
    final navigationProvider = Navigation();

    // Return the list of providers
    return [
      Provider<LocationRepository>(create: (_) => locationRepository),
      Provider<GetCurrentLocation>(create: (_) => getCurrentLocation),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<RiderHomeBloc>(
          create: (_) => RiderHomeBloc(getCurrentLocation)),
    ];
  }
}
