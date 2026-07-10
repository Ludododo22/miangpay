import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_message_model.dart';

class NotificationMessageCard extends StatelessWidget {
  const NotificationMessageCard({
    super.key,
    required this.notification,
    this.onMarkRead,
  });

  final NotificationMessageModel notification;
  final VoidCallback? onMarkRead;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: notification.isRead ? null : onMarkRead,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: notification.isRead
              ? null
              : Border.all(color: AppColors.secondary.withValues(alpha: .35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_icon, color: _color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        _relativeTime(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (!notification.isRead)
                        TextButton(
                          onPressed: onMarkRead,
                          child: const Text('Marquer lu'),
                        ),
                      if (notification.actionLabel != null)
                        TextButton(
                          onPressed: notification.actionRoute == null
                              ? null
                              : () => context.go(notification.actionRoute!),
                          child: Text(notification.actionLabel!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (notification.category) {
      case NotificationCategory.transaction:
        return Icons.swap_horiz_rounded;
      case NotificationCategory.security:
        return Icons.shield_rounded;
      case NotificationCategory.promotion:
        return Icons.local_offer_rounded;
      case NotificationCategory.loyalty:
        return Icons.workspace_premium_rounded;
      case NotificationCategory.card:
        return Icons.credit_card_rounded;
      case NotificationCategory.support:
        return Icons.support_agent_rounded;
      case NotificationCategory.all:
        return Icons.notifications_rounded;
    }
  }

  Color get _color {
    switch (notification.priority) {
      case NotificationPriority.critical:
        return AppColors.error;
      case NotificationPriority.important:
        return AppColors.secondary;
      case NotificationPriority.info:
        return AppColors.info;
      case NotificationPriority.marketing:
        return AppColors.accent;
    }
  }

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }
}
