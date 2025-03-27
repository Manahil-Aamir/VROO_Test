import 'package:vroo_test/features/sos/data/models/contact_model.dart';

import '../../domain/repository/sos_repository.dart';
import '../data_source/sos_data_source.dart';

class SosRepositoryImpl implements SosRepository {
  final SosDataSource remoteDataSource;

  SosRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String uid) {
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
  Future<String> triggerSOS(String uid) {
    return remoteDataSource.triggerSOS(uid);
  }
}
