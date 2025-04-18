import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/clear_preferences_usecase.dart';
import '../../../domain/usecase/get_current_location.dart';
import '../../../domain/usecase/get_user_usecase.dart';
import '../../../domain/usecase/logout_usecase.dart';
import '../event/home_event.dart';
import '../state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentLocation getCurrentLocation;
  final ClearPreferencesUseCase clearPreferences;
  final LogoutUseCase logout;
  final GetUserUseCase getUser;

  HomeBloc({
    required this.getCurrentLocation,
    required this.clearPreferences,
    required this.logout,
    required this.getUser,
  }) : super(HomeInitial()) {
    on<LoadCurrentLocationEvent>(_onLoadLocation);
    on<ClearPreferencesEvent>(_onClearPreferences);
    on<LogoutEvent>(_onLogout);
    on<LoadUserEvent>(_onLoadUser);
  }

  Future<void> _onLoadLocation(
    LoadCurrentLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final location = await getCurrentLocation.execute();
      emit(HomeLoaded(location));
    } catch (e) {
      emit(HomeError('Failed to load location'));
    }
  }

  Future<void> _onClearPreferences(
    ClearPreferencesEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await clearPreferences.execute();
    } catch (e) {
      emit(HomeError('Failed to clear preferences'));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await logout.execute();
      emit(HomeLogoutSuccess());
    } catch (e) {
      emit(HomeError('Logout failed'));
    }
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<HomeState> emit) async {
    final user = await getUser();
    if (user != null) {
      emit(UserLoadedState(user));
    } else {
      emit(NoUserFoundState());
    }
  }
}
