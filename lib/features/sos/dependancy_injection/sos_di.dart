import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/authentication/domain/usecases/get_token_usecase.dart';
import 'package:vroo_test/features/sos/data/data_source/sos_data_source.dart';
import 'package:vroo_test/features/sos/domain/usecases/delete_contact_usecase.dart';
import 'package:vroo_test/features/sos/domain/usecases/get_contacts_usecase.dart';
import 'package:vroo_test/features/sos/domain/usecases/save_contacts_usecase.dart';
import 'package:vroo_test/features/sos/domain/usecases/trigger_sos_usecase.dart';
import '../../../core/services/permission_handler.dart';
import '../../authentication/data/data_source/token_data_source.dart';
import '../../authentication/data/repository/token_repository_impl.dart';
import '../data/repository/sos_repository_impl.dart';
import '../domain/repository/sos_repository.dart';
import '../presentation/bloc/bloc/sos_bloc.dart';

class SosDependencyInjection {
  static List<SingleChildWidget> init() {
    final sosDataSource = SosDataSourceImpl();
    final sosRepository = SosRepositoryImpl(sosDataSource);
    final getContactsUseCase = GetEmergencyContacts(sosRepository);
    final saveContactsUseCase = AddEmergencyContact(sosRepository);
    final deleteContactUseCase = DeleteEmergencyContact(sosRepository);
    final triggerSosUseCase = TriggerSOS(sosRepository);
    final permissionService = PermissionService();

    final firebaseAuth = FirebaseAuth.instance;
    final tokenDataSource =
        TokenRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
    final tokenRepository = TokenRepositoryImpl(tokenDataSource);
    final getTokenUseCase = GetTokenUseCase(tokenRepository);

    return [
      Provider<SosDataSource>(create: (_) => sosDataSource),
      Provider<SosRepository>(create: (_) => sosRepository),
      Provider<GetEmergencyContacts>(create: (_) => getContactsUseCase),
      Provider<AddEmergencyContact>(create: (_) => saveContactsUseCase),
      Provider<DeleteEmergencyContact>(create: (_) => deleteContactUseCase),
      Provider<TriggerSOS>(create: (_) => triggerSosUseCase),
      Provider<PermissionService>(create: (_) => permissionService),
      BlocProvider<SosBloc>(
        create: (_) => SosBloc(
          getEmergencyContacts: getContactsUseCase,
          addEmergencyContact: saveContactsUseCase,
          deleteEmergencyContact: deleteContactUseCase,
          triggerSOS: triggerSosUseCase,
          getTokenUsecase: getTokenUseCase,
        ),
      ),
    ];
  }
}
