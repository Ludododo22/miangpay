class ChatMessageModel {
  final String id;
  final String message;
  final bool fromUser;
  final DateTime sentAt;

  const ChatMessageModel({
    required this.id,
    required this.message,
    required this.fromUser,
    required this.sentAt,
  });
}
