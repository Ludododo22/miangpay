import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';

class TransferSuccessScreen extends ConsumerWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(transferDraftProvider).receipt;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            const CircleAvatar(radius: 48, backgroundColor: AppColors.secondary, child: Icon(Icons.check_rounded, size: 60, color: Colors.white)),
            const SizedBox(height: 24),
            const Text('Transfert effectué', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 12),
            Text(receipt == null ? 'Votre transfert a été enregistré.' : '${receipt.amount.toStringAsFixed(0)} ${receipt.currency} vers ${receipt.receiverName}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            PrimaryButton(label: 'Voir le reçu', icon: Icons.receipt_long_rounded, onPressed: () => context.go('/transfer/receipt')),
            const SizedBox(height: 12),
            SecondaryButton(label: 'Retour accueil', onPressed: () => context.go('/dashboard')),
          ]),
        ),
      ),
    );
  }
}
