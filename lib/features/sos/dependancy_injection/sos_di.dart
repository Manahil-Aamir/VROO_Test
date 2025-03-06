import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vroo_test/features/sos/data/data_source/sos_data_source.dart';

import '../../../core/services/permission_handler.dart';
import '../../../core/services/sms_service.dart';
import '../data/repository/sos_repository_impl.dart';
import '../domain/repository/sos_repository.dart';
import '../domain/usecases/get_contacts_usecase.dart';
import '../domain/usecases/save_contacts_usecase.dart';
import '../presentation/bloc/bloc/sos_bloc.dart';

class SosDependencyInjection {
  static List<SingleChildWidget> init() {
    // Initialize data sources
    final sosDataSource = SosLocalDataSource();

    // Initialize repository
    final sosRepository = SosRepositoryImpl(sosDataSource);

    // Initialize use cases
    final getContactsUseCase = GetContactsUseCase(sosRepository);
    final saveContactsUseCase = SaveContactsUseCase(sosRepository);

    // Initialize services
    final permissionService = PermissionService();
    final smsService = SmsService();

    return [
      // Data source
      Provider<SosDataSource>(create: (_) => sosDataSource),

      // Repository
      Provider<SosRepository>(create: (_) => sosRepository),

      // Use cases
      Provider<GetContactsUseCase>(create: (_) => getContactsUseCase),
      Provider<SaveContactsUseCase>(create: (_) => saveContactsUseCase),

      // Services
      Provider<PermissionService>(create: (_) => permissionService),
      Provider<SmsService>(create: (_) => smsService),

      // Bloc Provider
      BlocProvider<SosBloc>(
        create: (_) => SosBloc(
          getContacts: getContactsUseCase,
          saveContacts: saveContactsUseCase,
          permissionService: permissionService,
          smsService: smsService,
        ),
      ),
    ];
  }
}
