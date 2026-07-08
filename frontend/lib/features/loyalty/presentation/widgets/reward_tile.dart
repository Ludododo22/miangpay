import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/reward_model.dart';

class RewardTile extends StatelessWidget {
  const RewardTile({super.key, required this.reward});
  final RewardModel reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .12), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.card_giftcard_rounded, color: AppColors.secondary),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(reward.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 4),
          Text(reward.description, style: const TextStyle(color: AppColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${reward.pointsCost} pts', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 6),
          Text(reward.available ? 'Disponible' : 'Bientôt', style: TextStyle(color: reward.available ? AppColors.success : AppColors.warning, fontSize: 12)),
        ]),
      ]),
    );
  }
}
