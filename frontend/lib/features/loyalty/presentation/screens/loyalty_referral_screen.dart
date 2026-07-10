import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';

class LoyaltyReferralScreen extends ConsumerWidget {
  const LoyaltyReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(loyaltyRepositoryProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Parrainage')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(28)),
          child: Column(children: [
            const Icon(Icons.group_add_rounded, color: Colors.white, size: 54),
            const SizedBox(height: 16),
            const Text('Invitez vos proches',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Gagnez 500 points par filleul validé.',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18)),
              child: Text(repo.referralCode,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4)),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: _StatCard(label: 'Filleuls', value: '${repo.referrals}')),
          const SizedBox(width: 12),
          Expanded(
              child: _StatCard(
                  label: 'Points gagnés', value: '${repo.referrals * 500}')),
        ]),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Partager mon code',
          icon: Icons.share_rounded,
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Code de parrainage prêt à partager'))),
        ),
      ]),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      ]),
    );
  }
}
