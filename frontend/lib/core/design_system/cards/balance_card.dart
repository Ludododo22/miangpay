import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String equivalent;
  final String status;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.equivalent,
    this.status = 'Compte vérifié',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portefeuille', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Text(balance, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(equivalent, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(999)),
            child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
