import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/get_user_profile.dart';
import '../../../domain/usecase/update_user_profile.dart';
import '../event/user_profile_event.dart';
import '../state/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(UserProfileLoading()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onLoadUserProfile(LoadUserProfile event, Emitter<UserProfileState> emit) async {
    print('[UserProfileBloc] LoadUserProfile event triggered');
    emit(UserProfileLoading());
    try {
      final userProfile = await getUserProfile();
      print('[UserProfileBloc] User profile loaded: $userProfile');
      emit(UserProfileLoaded(userProfile: userProfile));
    } catch (e) {
      print('[UserProfileBloc] Failed to load profile: $e');
      emit(UserProfileError(message: 'Failed to load profile.'));
    }
  }

  void _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UserProfileState> emit) async {
    print('[UserProfileBloc] UpdateUserProfileEvent triggered with name=${event.name}, phone=${event.phoneNumber}');
    try {
      await updateUserProfile(name: event.name, phoneNumber: event.phoneNumber);
      print('[UserProfileBloc] Profile updated, reloading...');
      add(LoadUserProfile());
    } catch (e) {
      print('[UserProfileBloc] Failed to update profile: $e');
      emit(UserProfileError(message: 'Failed to update profile.'));
    }
  }
}
