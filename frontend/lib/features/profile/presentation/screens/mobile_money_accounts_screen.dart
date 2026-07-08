import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';

class MobileMoneyAccountsScreen extends ConsumerWidget {
  const MobileMoneyAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(mobileMoneyAccountsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Comptes Mobile Money')),
      body: accounts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Associez plusieurs comptes Mobile Money pour transférer plus rapidement selon le pays et l’opérateur.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),
            ...items.map((account) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Text(account.flag, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(account.operatorName, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text('${account.country} • ${account.phone}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ])),
                if (account.primary) const StatusBadge(label: 'Principal', status: AppStatus.success),
              ]),
            )),
            const SizedBox(height: 12),
            PrimaryButton(label: 'Ajouter un compte', icon: Icons.add_rounded, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
