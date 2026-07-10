import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';
import '../widgets/reward_tile.dart';

class RewardsStoreScreen extends ConsumerWidget {
  const RewardsStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(loyaltyOverviewProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Boutique recompenses')),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (data) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(Icons.stars_rounded, color: AppColors.secondary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Utilisez vos points pour reduire les frais, obtenir des transferts gratuits ou creer une carte virtuelle.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (final reward in data.rewards) RewardTile(reward: reward),
          ],
        ),
      ),
    );
  }
}
