import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/security_score_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Impossible de charger le profil')),
        data: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
              child: Row(children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.secondary,
                  child: Text(user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text('${user.flag} ${user.country} • ${user.operatorName}', style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  Row(children: [
                    const StatusBadge(label: 'KYC vérifié', status: AppStatus.success),
                    const SizedBox(width: 8),
                    StatusBadge(label: 'Niveau ${user.tier}', status: AppStatus.info),
                  ]),
                ])),
                IconButton(onPressed: () => context.push('/profile/edit'), icon: const Icon(Icons.edit_rounded)),
              ]),
            ),
            const SizedBox(height: 16),
            SecurityScoreCard(score: user.securityScore),
            const SizedBox(height: 18),
            Row(children: [
              _StatBox(label: 'Points', value: '${user.loyaltyPoints}'),
              const SizedBox(width: 10),
              const _StatBox(label: 'Cartes', value: '3'),
              const SizedBox(width: 10),
              const _StatBox(label: 'Transferts', value: '152'),
            ]),
            const SizedBox(height: 24),
            ProfileMenuTile(icon: Icons.account_balance_wallet_rounded, title: 'Comptes Mobile Money', subtitle: 'Gérer MTN, Moov, Orange...', onTap: () => context.push('/profile/mobile-money')),
            ProfileMenuTile(icon: Icons.verified_user_rounded, title: 'Sécurité', subtitle: 'PIN, biométrie, 2FA', onTap: () => context.push('/profile/security')),
            ProfileMenuTile(icon: Icons.badge_rounded, title: 'Documents KYC', subtitle: 'Statut, identité, expiration', onTap: () => context.push('/profile/kyc-status')),
            ProfileMenuTile(icon: Icons.devices_rounded, title: 'Appareils connectés', subtitle: 'Sessions actives et déconnexion', onTap: () => context.push('/profile/devices')),
            ProfileMenuTile(icon: Icons.notifications_rounded, title: 'Notifications', subtitle: 'Transactions, fidélité, promotions', onTap: () => context.push('/profile/notifications-settings')),
            ProfileMenuTile(icon: Icons.language_rounded, title: 'Langue & devise', subtitle: 'Français • XOF', onTap: () => context.push('/profile/preferences')),
            ProfileMenuTile(icon: Icons.card_giftcard_rounded, title: 'Parrainage', subtitle: 'Code JEAN2026 et bonus', onTap: () => context.push('/profile/referral')),
            ProfileMenuTile(icon: Icons.history_rounded, title: 'Journal de sécurité', subtitle: 'Connexions et actions sensibles', onTap: () => context.push('/profile/security-log')),
            ProfileMenuTile(icon: Icons.support_agent_rounded, title: 'Aide & support', subtitle: 'FAQ, chat, ticket', onTap: () => context.push('/support')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Déconnexion'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }
}
