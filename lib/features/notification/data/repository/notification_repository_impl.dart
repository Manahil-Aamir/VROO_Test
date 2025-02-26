import '../../domain/repository/notification_repository.dart';
import '../data_source/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendNotificationToken(String token) async {
    print('in data repo');
    return remoteDataSource.sendNotificationToken(token);
  }
}