import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/notifications_providers.dart';
import '../widgets/notification_setting_tile.dart';

class NotificationSettingsCenterScreen extends ConsumerWidget {
  const NotificationSettingsCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Préférences notifications')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur')),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            NotificationSettingTile(title: 'Transactions', subtitle: 'Succès, échec, suivi et reçus', value: settings.transactions),
            NotificationSettingTile(title: 'Sécurité', subtitle: 'Connexions, appareils, PIN et alertes', value: settings.security),
            NotificationSettingTile(title: 'Cartes', subtitle: 'Paiements, recharges et limites', value: settings.cards),
            NotificationSettingTile(title: 'Promotions', subtitle: 'Offres par pays et coupons', value: settings.promotions),
            NotificationSettingTile(title: 'Fidélité', subtitle: 'Points, niveaux et récompenses', value: settings.loyalty),
            NotificationSettingTile(title: 'Support', subtitle: 'Réponses aux tickets et messages', value: settings.support),
            NotificationSettingTile(title: 'Marketing', subtitle: 'Conseils et campagnes commerciales', value: settings.marketing),
          ],
        ),
      ),
    );
  }
}
