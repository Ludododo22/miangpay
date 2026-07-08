import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PromotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;

  const PromotionCard({super.key, required this.title, required this.subtitle, required this.tag, this.icon = Icons.local_offer_rounded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: .14), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: AppColors.accent),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .12), borderRadius: BorderRadius.circular(999)),
          child: Text(tag, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
        )
      ]),
    );
  }
}
