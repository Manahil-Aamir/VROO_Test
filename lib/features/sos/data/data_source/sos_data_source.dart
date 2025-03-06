import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact_model.dart';

abstract class SosDataSource {
  Future<List<ContactModel>> getContacts();
  Future<void> saveContacts(List<ContactModel> contacts);
}

class SosLocalDataSource implements SosDataSource {
  @override
  Future<List<ContactModel>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList('sos_contacts') ?? [];
    return contactsJson
        .map((e) =>
            ContactModel.fromMap(Map<String, String>.from(jsonDecode(e))))
        .toList();
  }

  @override
  Future<void> saveContacts(List<ContactModel> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = contacts.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('sos_contacts', contactsJson);
  }
}
