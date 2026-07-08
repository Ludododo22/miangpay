import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LoyaltyHeaderCard extends StatelessWidget {
  const LoyaltyHeaderCard({super.key, required this.points});
  final int points;

  @override
  Widget build(BuildContext context) {
    final progress = points / 3000;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('🥇', style: TextStyle(fontSize: 42)),
          SizedBox(width: 12),
          Expanded(child: Text('Niveau OR', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))),
        ]),
        const SizedBox(height: 12),
        Text('$points points', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: progress.clamp(0, 1), minHeight: 9, color: AppColors.secondary, backgroundColor: Colors.white24),
        ),
        const SizedBox(height: 10),
        Text('Encore ${3000 - points} points pour devenir Platine', style: const TextStyle(color: Colors.white70)),
      ]),
    );
  }
}
