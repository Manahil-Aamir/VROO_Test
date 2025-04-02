import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_user_profile.dart';
import '../event/user_profile_event.dart';
import '../state/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;

  UserProfileBloc({required this.getUserProfile}) : super(UserProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(UserProfileLoading());
      try {
        final userProfile = await getUserProfile();
        emit(UserProfileLoaded(userProfile: userProfile));
      } catch (e) {
        emit(UserProfileError(message: 'Failed to load user profile'));
      }
    });
  }
}
