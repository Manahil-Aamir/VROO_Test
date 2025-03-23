import 'package:vroo_test/features/sos/domain/entities/sos_entity.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

class SosModel extends SosEntity {
  SosModel({
    required super.sessionId,
    required super.sosLink,
    required super.emergencyContacts,
  });

  factory SosModel.fromMap(Map<String, dynamic> map) => SosModel(
        sessionId: map['sessionId'].toString(),
        sosLink: map['sosLink'],
        emergencyContacts: (map['emergencyContacts'] as List)
            .map((e) => ContactModel.fromMap(e))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'sosLink': sosLink,
        'emergencyContacts': emergencyContacts
            .map((contact) => (contact as ContactModel).toMap())
            .toList(),
      };
}
