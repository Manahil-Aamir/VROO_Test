import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({super.id, required super.name, required super.number});

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map['_id'],
        name: map['name'],
        number: map['phoneNumber'],
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        'phoneNumber': number,
      };
}
