import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../authentication/domain/usecases/get_token_usecase.dart';
import '../../../domain/usecase/clear_preferences_usecase.dart';
import '../../../domain/usecase/get_current_location.dart';
import '../../../domain/usecase/get_user_usecase.dart';
import '../../../domain/usecase/logout_usecase.dart';
import '../../../domain/usecase/ongoing_usecase.dart';
import '../event/home_event.dart';
import '../state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentLocation getCurrentLocation;
  final ClearPreferencesUseCase clearPreferences;
  final LogoutUseCase logout;
  final GetUserUseCase getUser;
  final OngoingUsecase checkOngoingTrip;
  final GetTokenUseCase getTokenUseCase;

  Timer? _ongoingTripTimer;

  HomeBloc({
    required this.getCurrentLocation,
    required this.clearPreferences,
    required this.logout,
    required this.getUser,
    required this.checkOngoingTrip,
    required this.getTokenUseCase,
  }) : super(HomeInitial()) {
    on<LoadCurrentLocationEvent>(_onLoadLocation);
    on<ClearPreferencesEvent>(_onClearPreferences);
    on<LogoutEvent>(_onLogout);
    on<LoadUserEvent>(_onLoadUser);
    on<CheckOngoingTripEvent>(_onCheckOngoingTrip);
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
      // Cancel the ongoing trip timer when logging out
      _cancelOngoingTripTimer();
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

      // Start checking for ongoing trips when user is loaded
      _startOngoingTripCheck();
    } else {
      emit(NoUserFoundState());
    }
  }

  Future<void> _onCheckOngoingTrip(
      CheckOngoingTripEvent event, Emitter<HomeState> emit) async {
    try {
      emit(OngoingTripLoading());

      // Get token through the use case
      final token = await getTokenUseCase();

      if (token == null) {
        emit(OngoingTripError('Unable to get authentication token'));
        return;
      }
      print("helooooooooo");

      final trip = await checkOngoingTrip(token);

      emit(OngoingTripLoaded(trip));
    } catch (e) {
      emit(OngoingTripError('Failed to fetch ongoing trip: ${e.toString()}'));
    }
  }

  // Method to start periodic checking of ongoing trips
  void _startOngoingTripCheck() {
    // Cancel any existing timer
    _cancelOngoingTripTimer();

    // Perform initial check
    add(CheckOngoingTripEvent());

    // Start periodic timer (every 15 minutes)
    _ongoingTripTimer = Timer.periodic(
        const Duration(minutes: 15), (_) => add(CheckOngoingTripEvent()));
  }

  // Cancel the ongoing trip timer
  void _cancelOngoingTripTimer() {
    _ongoingTripTimer?.cancel();
    _ongoingTripTimer = null;
  }

  @override
  Future<void> close() {
    _cancelOngoingTripTimer();
    return super.close();
  }
}
