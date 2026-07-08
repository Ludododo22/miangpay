import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/cards_providers.dart';

class CardSettingsScreen extends ConsumerWidget {
  final String cardId;

  const CardSettingsScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(selectedCardProvider(cardId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Paramètres carte')),
      body: cardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (card) {
          if (card == null) return const Center(child: Text('Carte introuvable'));
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SettingTile(
                icon: Icons.label_rounded,
                title: 'Nom de la carte',
                subtitle: card.label,
              ),
              _SettingTile(
                icon: Icons.public_rounded,
                title: 'Paiements en ligne',
                subtitle: card.onlinePaymentsEnabled ? 'Activés' : 'Désactivés',
                trailing: Switch(value: card.onlinePaymentsEnabled, onChanged: (_) {}),
              ),
              _SettingTile(
                icon: Icons.today_rounded,
                title: 'Limite quotidienne',
                subtitle: '${card.dailyLimit.toStringAsFixed(0)} ${card.currency}',
              ),
              _SettingTile(
                icon: Icons.calendar_month_rounded,
                title: 'Limite mensuelle',
                subtitle: '${card.monthlyLimit.toStringAsFixed(0)} ${card.currency}',
              ),
              _SettingTile(
                icon: Icons.security_rounded,
                title: 'Protection PIN / biométrie',
                subtitle: 'Requise pour afficher les informations sensibles',
              ),
              _SettingTile(
                icon: Icons.delete_outline_rounded,
                title: 'Supprimer la carte',
                subtitle: 'Action désactivée en démo',
                danger: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool danger;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.secondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppColors.background, child: Icon(icon, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w900, color: danger ? AppColors.error : AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ])),
        trailing ?? const Icon(Icons.chevron_right_rounded),
      ]),
    );
  }
}
