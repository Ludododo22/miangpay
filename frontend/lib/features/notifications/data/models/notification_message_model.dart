enum NotificationCategory { all, transaction, security, promotion, loyalty, card, support }
enum NotificationPriority { critical, important, info, marketing }

class NotificationMessageModel {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final NotificationPriority priority;
  final DateTime createdAt;
  final bool isRead;
  final String? actionLabel;
  final String? actionRoute;

  const NotificationMessageModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.priority,
    required this.createdAt,
    this.isRead = false,
    this.actionLabel,
    this.actionRoute,
  });

  NotificationMessageModel copyWith({bool? isRead}) {
    return NotificationMessageModel(
      id: id,
      title: title,
      body: body,
      category: category,
      priority: priority,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      actionLabel: actionLabel,
      actionRoute: actionRoute,
    );
  }
}
