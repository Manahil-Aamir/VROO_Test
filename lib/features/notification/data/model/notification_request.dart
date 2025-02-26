class NotificationRequest {
  final String token;

  NotificationRequest(this.token);

  Map<String, String> toJson() => {'fcmToken': token};
}