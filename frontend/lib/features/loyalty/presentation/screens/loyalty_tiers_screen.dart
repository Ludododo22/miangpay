import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';
import '../widgets/tier_tile.dart';

class LoyaltyTiersScreen extends ConsumerWidget {
  const LoyaltyTiersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(loyaltyOverviewProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Niveaux')),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (data) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Plus vous utilisez MiangPay, plus vos frais baissent.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            for (final tier in data.tiers)
              TierTile(tier: tier, isCurrent: tier.name == data.currentTier),
          ],
        ),
      ),
    );
  }
}
