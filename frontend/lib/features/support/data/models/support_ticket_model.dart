class SupportTicketModel {
  final String id;
  final String subject;
  final String category;
  final String status;
  final String lastMessage;
  final DateTime createdAt;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.lastMessage,
    required this.createdAt,
  });
}
