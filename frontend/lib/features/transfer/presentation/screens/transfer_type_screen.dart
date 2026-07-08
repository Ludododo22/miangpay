import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';

class TransferTypeScreen extends ConsumerWidget {
  const TransferTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      ('send', Icons.send_rounded, 'Envoyer de l’argent', 'Vers un bénéficiaire Mobile Money'),
      ('receive', Icons.call_received_rounded, 'Recevoir', 'Générer une demande de paiement'),
      ('withdraw', Icons.account_balance_wallet_rounded, 'Retirer', 'Retrait vers Mobile Money'),
      ('repeat', Icons.replay_rounded, 'Refaire un transfert', 'Reprendre une opération récente'),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Transfert')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final action = actions[index];
          return ListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading: CircleAvatar(backgroundColor: AppColors.secondary.withValues(alpha: .12), child: Icon(action.$2, color: AppColors.secondary)),
            title: Text(action.$3, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text(action.$4),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              ref.read(transferDraftProvider.notifier).setType(action.$1);
              context.go('/transfer/countries');
            },
          );
        },
      ),
    );
  }
}
