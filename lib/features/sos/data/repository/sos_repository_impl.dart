import 'package:vroo_test/features/sos/data/models/contact_model.dart';

import '../../domain/repository/sos_repository.dart';
import '../data_source/sos_data_source.dart';

class SosRepositoryImpl implements SosRepository {
  final SosDataSource remoteDataSource;

  SosRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> addEmergencyContact(
      ContactModel contact, String token) {
    return remoteDataSource.addEmergencyContact(contact, token);
  }

  @override
  Future<List<ContactModel>> getEmergencyContacts(String token) {
    return remoteDataSource.getEmergencyContacts(token);
  }

  @override
  Future<bool> deleteEmergencyContact(String contactId, String token) {
    return remoteDataSource.deleteEmergencyContact(contactId, token);
  }

  @override
  Future<String> triggerSOS(String token) {
    return remoteDataSource.triggerSOS(token);
  }
}
