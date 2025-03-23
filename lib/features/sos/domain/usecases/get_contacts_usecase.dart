import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import '../repository/sos_repository.dart';

class GetEmergencyContacts {
  final SosRepository repository;

  GetEmergencyContacts(this.repository);

  Future<List<ContactModel>> call(String uid) {
    print('GetEmergencyContacts called');
    return repository.getEmergencyContacts(uid);
  }
}
