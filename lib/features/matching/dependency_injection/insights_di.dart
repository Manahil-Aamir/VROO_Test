import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/data_source/insights_data_sources.dart';
import '../data/repository/insights_respository_impl.dart';
import '../domain/repository/insights_repository.dart';
import '../domain/usecase/get_insights_usecase.dart';
import '../presentation/bloc/bloc/insights_bloc.dart';

class DriverInsightsDependencyInjection {
  static List<SingleChildWidget> init() {
    final firebaseAuth = FirebaseAuth.instance; 
    final dataSource = DriverInsightsDataSourceImpl(client: Client());
    final repository = DriverInsightsRepositoryImpl(dataSource, firebaseAuth: firebaseAuth);
    final useCase = GetDriverInsightsUseCase(repository);

    return [
      Provider<DriverInsightsDataSource>(create: (_) => dataSource), 
      Provider<DriverInsightsRepository>(create: (_) => repository),
      Provider<GetDriverInsightsUseCase>(create: (_) => useCase),
      BlocProvider<DriverInsightsBloc>(
        create: (_) => DriverInsightsBloc(useCase),
      ),
    ];
  }
}
