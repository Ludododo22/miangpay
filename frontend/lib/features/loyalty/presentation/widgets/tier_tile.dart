import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/loyalty_tier_model.dart';

class TierTile extends StatelessWidget {
  const TierTile({super.key, required this.tier, required this.isCurrent});
  final LoyaltyTierModel tier;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCurrent ? AppColors.secondary : Colors.transparent, width: 1.5),
      ),
      child: Row(children: [
        Text(tier.icon, style: const TextStyle(fontSize: 34)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tier.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 4),
          Text(tier.description, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('${tier.feeDiscount.toStringAsFixed(0)}% réduction • ${tier.freeTransfers} transfert(s) gratuit(s)', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700, fontSize: 12)),
        ])),
        if (isCurrent) const Icon(Icons.check_circle_rounded, color: AppColors.secondary),
      ]),
    );
  }
}
