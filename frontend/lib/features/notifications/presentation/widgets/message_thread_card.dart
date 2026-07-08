import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/message_thread_model.dart';

class MessageThreadCard extends StatelessWidget {
  final MessageThreadModel thread;

  const MessageThreadCard({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: .08),
            child: Icon(_icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(thread.title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(thread.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (thread.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(999)),
              child: Text('${thread.unreadCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  IconData get _icon {
    switch (thread.type) {
      case 'Support':
        return Icons.support_agent_rounded;
      case 'Sécurité':
        return Icons.lock_rounded;
      case 'Marketing':
        return Icons.campaign_rounded;
      default:
        return Icons.chat_bubble_rounded;
    }
  }
}
