import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';
import '../widgets/challenge_card.dart';
import '../widgets/loyalty_header_card.dart';
import '../widgets/reward_tile.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(loyaltyPointsProvider);
    final rewards = ref.watch(rewardsProvider);
    final challenges = ref.watch(loyaltyChallengesProvider);
    final activities = ref.watch(loyaltyActivitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fidélité'),
        actions: [IconButton(onPressed: () => context.push('/loyalty/history'), icon: const Icon(Icons.history_rounded))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          LoyaltyHeaderCard(points: points),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _ShortcutCard(label: 'Niveaux', icon: Icons.workspace_premium_rounded, onTap: () => context.push('/loyalty/tiers'))),
            const SizedBox(width: 12),
            Expanded(child: _ShortcutCard(label: 'Boutique', icon: Icons.storefront_rounded, onTap: () => context.push('/loyalty/rewards'))),
            const SizedBox(width: 12),
            Expanded(child: _ShortcutCard(label: 'Parrainage', icon: Icons.group_add_rounded, onTap: () => context.push('/loyalty/referral'))),
          ]),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Défis actifs', action: 'Voir tout', onTap: () => context.push('/loyalty/challenges')),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView(scrollDirection: Axis.horizontal, children: [for (final challenge in challenges) ChallengeCard(challenge: challenge)]),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Récompenses populaires', action: 'Boutique', onTap: () => context.push('/loyalty/rewards')),
          const SizedBox(height: 12),
          ...rewards.take(2).map((reward) => RewardTile(reward: reward)),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Activité récente', action: 'Historique', onTap: () => context.push('/loyalty/history')),
          const SizedBox(height: 12),
          ...activities.take(3).map((activity) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                child: Row(children: [
                  const Icon(Icons.add_circle_rounded, color: AppColors.secondary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('+${activity.points}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
                ]),
              )),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, required this.onTap});
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      TextButton(onPressed: onTap, child: Text(action)),
    ]);
  }
}
