import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserProfileEvent extends UserProfileEvent {
  final String? name;
  final String? phoneNumber;

  UpdateUserProfileEvent({this.name, this.phoneNumber});

  @override
  List<Object?> get props => [name, phoneNumber];
}
