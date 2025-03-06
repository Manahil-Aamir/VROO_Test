import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import 'package:vroo_test/features/sos/domain/repository/sos_repository.dart';

class SaveContactsUseCase {
  final SosRepository repository;
  SaveContactsUseCase(this.repository);
  Future<void> call(List<ContactModel> contacts) =>
      repository.saveContacts(contacts);
}
