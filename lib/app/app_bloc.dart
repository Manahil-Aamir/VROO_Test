import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;

  AppBloc({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    try {
      final initialUser = _auth.currentUser;
      if (initialUser != null) {
        emit(AppAuthenticated());
      } else {
        emit(AppUnauthenticated());
      }

      _authSubscription?.cancel();
      _authSubscription = _auth.authStateChanges().listen((user) {
        if (user != null && state is! AppAuthenticated) {
          emit(AppAuthenticated());
        } else if (user == null && state is! AppUnauthenticated) {
          emit(AppUnauthenticated());
        }
      });
    } catch (e) {
      emit(AppUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

