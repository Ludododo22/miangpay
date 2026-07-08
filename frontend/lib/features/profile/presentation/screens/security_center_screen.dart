import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/security_score_card.dart';
import '../widgets/setting_section_title.dart';

class SecurityCenterScreen extends ConsumerWidget {
  const SecurityCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final pinEnabled = ref.watch(pinEnabledProvider);
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final twoFactorEnabled = ref.watch(twoFactorEnabledProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Sécurité')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          profile.maybeWhen(data: (user) => SecurityScoreCard(score: user.securityScore), orElse: () => const SizedBox.shrink()),
          const SettingSectionTitle('Protections'),
          _SwitchTile(title: 'PIN à 6 chiffres', subtitle: 'Demandé pour les opérations sensibles', value: pinEnabled, onChanged: (v) => ref.read(pinEnabledProvider.notifier).state = v),
          _SwitchTile(title: 'Biométrie', subtitle: 'Déverrouillage par empreinte ou visage', value: biometricEnabled, onChanged: (v) => ref.read(biometricEnabledProvider.notifier).state = v),
          _SwitchTile(title: 'Double authentification', subtitle: 'Protection renforcée sur nouvel appareil', value: twoFactorEnabled, onChanged: (v) => ref.read(twoFactorEnabledProvider.notifier).state = v),
          const SettingSectionTitle('Actions'),
          ProfileMenuTile(icon: Icons.lock_reset_rounded, title: 'Changer le PIN', subtitle: 'Mettre à jour votre code secret'),
          ProfileMenuTile(icon: Icons.devices_rounded, title: 'Appareils connectés', subtitle: 'Voir les sessions actives', onTap: () => context.push('/profile/devices')),
          ProfileMenuTile(icon: Icons.history_rounded, title: 'Journal de sécurité', subtitle: 'Consulter les actions sensibles', onTap: () => context.push('/profile/security-log')),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ])),
        Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.secondary),
      ]),
    );
  }
}
