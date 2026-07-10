import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';
import '../widgets/receipt_card.dart';

class TransferReceiptScreen extends ConsumerWidget {
  const TransferReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(transferDraftProvider).receipt;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reçu')),
      body: receipt == null
          ? const Center(child: Text('Aucun reçu disponible'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                ReceiptCard(receipt: receipt),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Partager',
                  icon: Icons.share_rounded,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reçu prêt à partager'))),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                    label: 'Terminer',
                    onPressed: () => context.go('/dashboard')),
              ]),
            ),
    );
  }
}
