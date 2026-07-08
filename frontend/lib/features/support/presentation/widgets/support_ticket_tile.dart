import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/support_ticket_model.dart';

class SupportTicketTile extends StatelessWidget {
  final SupportTicketModel ticket;
  const SupportTicketTile({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isResolved = ticket.status.toLowerCase().contains('résolu');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('${ticket.id} • ${ticket.category}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: (isResolved ? AppColors.success : AppColors.warning).withValues(alpha: .12), borderRadius: BorderRadius.circular(999)),
            child: Text(ticket.status, style: TextStyle(color: isResolved ? AppColors.success : AppColors.warning, fontSize: 12, fontWeight: FontWeight.w900)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(ticket.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text(ticket.lastMessage, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
      ]),
    );
  }
}
