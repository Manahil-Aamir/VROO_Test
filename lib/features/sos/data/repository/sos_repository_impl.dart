import '../../domain/repository/sos_repository.dart';
import '../data_source/sos_data_source.dart';
import '../models/contact_model.dart';

class SosRepositoryImpl implements SosRepository {
  final SosDataSource dataSource;

  SosRepositoryImpl(this.dataSource);

  @override
  Future<List<ContactModel>> getContacts() {
    return dataSource.getContacts();
  }

  @override
  Future<void> saveContacts(List<ContactModel> contacts) async {
    dataSource.saveContacts(contacts);
  }
}
