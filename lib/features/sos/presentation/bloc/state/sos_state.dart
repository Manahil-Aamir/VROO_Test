import 'package:equatable/equatable.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

abstract class SosState extends Equatable {
  @override
  List<Object> get props => [];
}

class SosInitial extends SosState {}

class SosLoading extends SosState {}

// Successfully loaded contacts
class SosLoaded extends SosState {
  final List<ContactModel> contacts;

  SosLoaded(this.contacts);

  @override
  List<Object> get props => [contacts];
}

// Successfully triggered SOS
class SosTriggered extends SosState {
  final String sosLink;

  SosTriggered(this.sosLink);

  @override
  List<Object> get props => [sosLink];
}

class SosError extends SosState {
  final String message;

  SosError(this.message);

  @override
  List<Object> get props => [message];
}
