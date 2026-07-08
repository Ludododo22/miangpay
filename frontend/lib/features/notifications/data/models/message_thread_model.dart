class MessageThreadModel {
  final String id;
  final String title;
  final String lastMessage;
  final String type;
  final DateTime updatedAt;
  final int unreadCount;

  const MessageThreadModel({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.type,
    required this.updatedAt,
    this.unreadCount = 0,
  });
}
