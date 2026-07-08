import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Paramètres notifications')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _NotificationSwitch(title: 'Transactions', subtitle: 'Succès, échec, reçu, suivi', provider: transactionNotificationsProvider),
          _NotificationSwitch(title: 'Promotions', subtitle: 'Coupons et offres personnalisées', provider: promotionNotificationsProvider),
          _NotificationSwitch(title: 'Fidélité', subtitle: 'Points, niveaux et récompenses', provider: loyaltyNotificationsProvider),
          _NotificationSwitch(title: 'Marketing', subtitle: 'Nouveautés et campagnes', provider: marketingNotificationsProvider),
        ],
      ),
    );
  }
}

class _NotificationSwitch extends ConsumerWidget {
  final String title;
  final String subtitle;
  final StateProvider<bool> provider;

  const _NotificationSwitch({required this.title, required this.subtitle, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
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
        Switch(value: value, onChanged: (v) => ref.read(provider.notifier).state = v, activeThumbColor: AppColors.secondary),
      ]),
    );
  }
}
