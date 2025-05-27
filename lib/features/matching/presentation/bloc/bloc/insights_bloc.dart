import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_insights_usecase.dart';
import '../event/insights_event.dart';
import '../state/insights_state.dart';

class DriverInsightsBloc extends Bloc<DriverInsightsEvent, DriverInsightsState> {
  final GetDriverInsightsUseCase useCase;

  DriverInsightsBloc(this.useCase) : super(DriverInsightsInitial()) {
    on<LoadDriverInsights>((event, emit) async {
      try {
        print('BLoC: Loading driver insights for ${event.driverId}'); // Debug log
        emit(DriverInsightsLoading());
        
        final result = await useCase(event.driverId);
        print('BLoC: Successfully loaded insights'); // Debug log
        emit(DriverInsightsLoaded(result));
      } catch (e) {
        print('BLoC: Error loading insights: $e'); // Debug log
        emit(DriverInsightsError('Failed to load driver insights: ${e.toString()}'));
      }
    });
  }
}
