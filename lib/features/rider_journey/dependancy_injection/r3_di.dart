import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/rider_journey/domain/repository/r3_repository.dart';
import 'package:vroo_test/features/rider_journey/domain/usecases/get_coordinates_usecase.dart';
import 'package:vroo_test/features/rider_journey/presentation/bloc/bloc/r3_bloc.dart';
import '../../../core/router/navigation.dart';
import '../data/data_source/r3_data_source.dart';
import '../data/repository/r3_repository_impl.dart';
import '../domain/usecases/request_ride_usecase.dart';

class R3DependancyInjection {
  static List<SingleChildWidget> init() {
    final rideRequestDataSource = R3DataSource(client: Client());
    final rideRequestRepository = R3RepositoryImpl(rideRequestDataSource);
    final requestRideUseCase = RequestRideUseCase(rideRequestRepository);
    final getCoordinatesUsecase = GetCoordinatesUseCase(rideRequestRepository);
    final navigationProvider = Navigation();

    return [
      Provider<R3DataSource>(create: (_) => rideRequestDataSource),
      Provider<R3Repository>(create: (_) => rideRequestRepository),
      Provider<RequestRideUseCase>(create: (_) => requestRideUseCase),
      Provider<Navigation>(create: (_) => navigationProvider),
      BlocProvider<R3Bloc>(
          create: (_) => R3Bloc(requestRideUseCase, getCoordinatesUsecase)),
    ];
  }
}
