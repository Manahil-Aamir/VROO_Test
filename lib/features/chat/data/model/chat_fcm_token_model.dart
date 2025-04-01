class ChatUserModel {
  final String id;
  final String name;
  final String fcmToken;
  final String source;
  final String destination;
  final DateTime date;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.fcmToken,
    required this.source,
    required this.destination,
    required this.date,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['riderId'] ?? json['driverId'] ?? '',  // Handle both cases
      name: json['name'] ?? json['driverName'] ?? '', // Handle both cases
      fcmToken: json['fcmToken'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
    );  
  }
}
