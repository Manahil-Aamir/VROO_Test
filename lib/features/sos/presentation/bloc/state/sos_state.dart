import 'package:vroo_test/features/sos/data/models/contact_model.dart';

abstract class SosState {}

class SosInitial extends SosState {}

class SosLoaded extends SosState {
  final List<ContactModel> contacts;
  SosLoaded(this.contacts);
}

class PermissionsGranted extends SosState {}

class SosSent extends SosState {}
