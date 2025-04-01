class ChatUser {
  final String id;
  final String name;
  final String fcmToken;
  final String source;
  final String destination;
  final DateTime date;

  ChatUser({
    required this.id,
    required this.name,
    required this.fcmToken,
    required this.source,
    required this.destination,
    required this.date,
  });
}
