import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/sos/data/models/contact_model.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../../core/services/permission_handler.dart';
import '../../../../../core/services/sms_service.dart';
import '../../../domain/usecases/get_contacts_usecase.dart';
import '../../../domain/usecases/save_contacts_usecase.dart';
import '../event/sos_event.dart';
import '../state/sos_state.dart';

class SosBloc extends Bloc<SosEvent, SosState> {
  final GetContactsUseCase getContacts;
  final SaveContactsUseCase saveContacts;
  final PermissionService permissionService;
  final SmsService smsService;

  SosBloc({
    required this.getContacts,
    required this.saveContacts,
    required this.permissionService,
    required this.smsService,
  }) : super(SosInitial()) {
    on<LoadContacts>((event, emit) async {
      final contacts = await getContacts();
      emit(SosLoaded(contacts));
    });
    on<SaveContacts>((event, emit) async {
      await saveContacts(event.contacts);
      emit(SosLoaded(event.contacts));
    });
    on<RequestPermissions>((event, emit) async {
      bool smsGranted = await permissionService.requestSmsPermission();
      bool contactsGranted =
          await permissionService.requestContactsPermission();
      if (smsGranted && contactsGranted) {
        emit(PermissionsGranted());
      }
    });
    on<SendSos>((event, emit) async {
      final contacts = await getContacts();
      if (contacts.isNotEmpty) {
        await smsService.sendSosMessage(contacts);
        emit(SosSent());
      }
    });
    on<PickContact>((event, emit) async {
      if (await permissionService.requestContactsPermission()) {
        final contact = await FlutterContacts.openExternalPick();
        if (contact != null && contact.phones.isNotEmpty) {
          final newContact = ContactModel(
            name: contact.displayName.isNotEmpty
                ? contact.displayName
                : "Unknown",
            number: contact.phones.first.number, // Correct field
          );
          final currentContacts = await getContacts();
          if (currentContacts.length < 3) {
            currentContacts.add(newContact);
            await saveContacts(currentContacts);
            emit(SosLoaded(currentContacts));
          }
        }
      }
    });
  }
}
