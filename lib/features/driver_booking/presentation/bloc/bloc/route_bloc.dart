import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_routes.dart';
import '../event/route_event.dart';
import '../state/route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final FetchRoutesUseCase fetchRoutesUseCase;

  RouteBloc({required this.fetchRoutesUseCase}) : super(RouteInitial()) {
    on<FetchRoutesEvent>((event, emit) async {
      emit(RouteLoading());
      try {
        final routeData = await fetchRoutesUseCase(event.fromPlaceId, event.toPlaceId);
        emit(RouteLoaded(routeData!));
      } catch (e) {
        emit(RouteError(e.toString()));
      }
    });
  }
}
