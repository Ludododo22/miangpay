import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SavingsCenterScreen extends StatelessWidget {
  const SavingsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Promotions', '18 000 XOF'),
      ('Fidélité', '12 000 XOF'),
      ('Niveau Or', '8 000 XOF'),
      ('Parrainages', '4 350 XOF'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Centre des économies')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(28)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Vous avez économisé', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('42 350 XOF', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Grâce aux promotions, points et avantages MiangPay.', style: TextStyle(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 20),
          for (final row in rows)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Text(row.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                Text(row.$2, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
              ]),
            ),
        ],
      ),
    );
  }
}
