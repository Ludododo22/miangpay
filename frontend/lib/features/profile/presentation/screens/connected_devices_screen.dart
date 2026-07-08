import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';

class ConnectedDevicesScreen extends ConsumerWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(securityDevicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Appareils connectés')),
      body: devices.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Vérifiez les appareils qui ont accès à votre compte MiangPay.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 18),
            ...items.map((device) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Container(height: 48, width: 48, decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .1), borderRadius: BorderRadius.circular(16)), child: Icon(device.name.toLowerCase().contains('chrome') ? Icons.computer_rounded : Icons.phone_iphone_rounded, color: AppColors.secondary)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Expanded(child: Text(device.name, style: const TextStyle(fontWeight: FontWeight.w900))), if (device.current) const StatusBadge(label: 'Actuel', status: AppStatus.success)]),
                  const SizedBox(height: 6),
                  Text(device.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  Text(device.lastActive, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ])),
                if (!device.current) TextButton(onPressed: () {}, child: const Text('Retirer')),
              ]),
            )),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Déconnecter tous les autres appareils'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}
