import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';
import '../widgets/tier_tile.dart';

class LoyaltyTiersScreen extends ConsumerWidget {
  const LoyaltyTiersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiers = ref.watch(loyaltyTiersProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Niveaux')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Plus vous utilisez MiangPay, plus vos frais baissent.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 20),
          for (final tier in tiers) TierTile(tier: tier, isCurrent: tier.name == 'Or'),
        ],
      ),
    );
  }
}
