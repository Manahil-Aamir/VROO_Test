import 'package:vroo_test/features/sos/data/models/contact_model.dart';

class SosEntity {
  final String sessionId;
  final String sosLink;
  final List<ContactModel> emergencyContacts;

  SosEntity({
    required this.sessionId,
    required this.sosLink,
    required this.emergencyContacts,
  });
}
