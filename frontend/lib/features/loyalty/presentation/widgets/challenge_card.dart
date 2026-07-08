import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/loyalty_challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.challenge});
  final LoyaltyChallengeModel challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 8),
        Text(challenge.description, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        LinearProgressIndicator(value: challenge.ratio.clamp(0, 1), color: AppColors.secondary, backgroundColor: AppColors.background),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${challenge.progress}/${challenge.target}', style: const TextStyle(fontWeight: FontWeight.w800)),
          Text('+${challenge.rewardPoints} pts', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 4),
        Text(challenge.deadline, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ]),
    );
  }
}
