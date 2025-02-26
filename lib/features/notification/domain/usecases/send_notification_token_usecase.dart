import '../repository/notification_repository.dart';

class SendNotificationTokenUseCase {
  final NotificationRepository repository;

  SendNotificationTokenUseCase(this.repository);

  Future<void> call(String token) async {
    print('in usecase');
    return repository.sendNotificationToken(token);
  }
}