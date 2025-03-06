import 'package:vroo_test/features/sos/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({required super.name, required super.number});

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        name: map['name'],
        number: map['number'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'number': number,
      };
}
