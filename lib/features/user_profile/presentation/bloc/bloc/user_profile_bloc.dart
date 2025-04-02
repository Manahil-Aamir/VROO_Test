import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_user_profile.dart';
import '../../../domain/usecase/update_user_profile.dart';
import '../event/user_profile_event.dart';
import '../state/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  UserProfileBloc({required this.getUserProfile, required this.updateUserProfile})
      : super(UserProfileLoading()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onLoadUserProfile(LoadUserProfile event, Emitter<UserProfileState> emit) async {
    try {
      final userProfile = await getUserProfile();
      emit(UserProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(UserProfileError(message: 'Failed to load profile.'));
    }
  }

  void _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UserProfileState> emit) async {
    try {
      await updateUserProfile(name: event.name, phoneNumber: event.phoneNumber);
      add(LoadUserProfile()); // Refresh user profile after update
    } catch (e) {
      emit(UserProfileError(message: 'Failed to update profile.'));
    }
  }
}
