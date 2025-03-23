import 'package:sms_advanced/contact.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';

import '../../domain/repository/sos_repository.dart';
import '../data_source/sos_data_source.dart';

class SosRepositoryImpl implements SosRepository {
  final SosDataSource remoteDataSource;

  SosRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> addEmergencyContact(ContactModel contact, String uid) {
    return remoteDataSource.addEmergencyContact(contact, uid);
  }

  @override
  Future<List<ContactModel>> getEmergencyContacts(String uid) {
    return remoteDataSource.getEmergencyContacts(uid);
  }

  @override
  Future<bool> deleteEmergencyContact(String uid, String contactId) {
    return remoteDataSource.deleteEmergencyContact(uid, contactId);
  }

  @override
  Future<void> triggerSOS(String uid) {
    return remoteDataSource.triggerSOS(uid);
  }
}
