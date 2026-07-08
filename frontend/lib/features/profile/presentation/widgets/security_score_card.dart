import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SecurityScoreCard extends StatelessWidget {
  final int score;

  const SecurityScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 72,
                width: 72,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: Colors.white24,
                  color: AppColors.secondary,
                ),
              ),
              Text('$score%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Centre de confiance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text('Votre compte est bien protégé. Activez toutes les options pour atteindre 100%.', style: TextStyle(color: Colors.white70, height: 1.35)),
            ]),
          ),
        ],
      ),
    );
  }
}
