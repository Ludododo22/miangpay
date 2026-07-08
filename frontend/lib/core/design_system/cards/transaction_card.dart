import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../badges/status_badge.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final AppStatus status;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.status = AppStatus.success,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.swap_horiz_rounded, color: AppColors.secondary)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                StatusBadge(label: _label(status), status: status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _label(AppStatus status) {
    switch (status) {
      case AppStatus.success:
        return 'Réussi';
      case AppStatus.pending:
        return 'En cours';
      case AppStatus.failed:
        return 'Échec';
      case AppStatus.info:
        return 'Info';
    }
  }
}
