import 'contact_entity.dart';

class SosEntity {
  final String sessionId;
  final String sosLink;
  final List<ContactEntity> emergencyContacts;

  SosEntity({
    required this.sessionId,
    required this.sosLink,
    required this.emergencyContacts,
  });
}
