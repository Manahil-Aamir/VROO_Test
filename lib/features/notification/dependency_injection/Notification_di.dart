import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/data_source/notification_remote_data_source.dart';
import '../data/repository/notification_repository_impl.dart';
import '../domain/repository/notification_repository.dart';
import '../domain/usecases/send_notification_token_usecase.dart';
import 'package:http/http.dart' as http;

class NotificationDependencyInjection {
  static List<SingleChildWidget> essentialProviders() {
    return [
      Provider<NotificationRemoteDataSource>(
        create: (_) => NotificationRemoteDataSource(http.Client()),
      ),
      Provider<NotificationRepository>(
        create: (context) => NotificationRepositoryImpl(
          context.read<NotificationRemoteDataSource>(),
        ),
      ),
      Provider<SendNotificationTokenUseCase>(
        create: (context) => SendNotificationTokenUseCase(
          context.read<NotificationRepository>(),
        ),
      ),
    ];
  }
}
