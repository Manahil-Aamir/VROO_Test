import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import 'package:vroo_test/features/sos/data/repository/sos_repository_impl.dart';

class GetContactsUseCase {
  final SosRepositoryImpl repository;
  GetContactsUseCase(this.repository);
  Future<List<ContactModel>> call() => repository.getContacts();
}
