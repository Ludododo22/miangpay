import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/history_providers.dart';

class HistoryReceiptScreen extends ConsumerWidget {
  final String reference;

  const HistoryReceiptScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionByReferenceProvider(reference));

    if (transaction == null) {
      return const Scaffold(
        body: AppEmptyState(icon: Icons.receipt_long_rounded, title: 'Reçu indisponible', message: 'Aucune transaction liée à cette référence.'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reçu')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28)),
            child: Column(
              children: [
                const Text('MiangPay', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text('Reçu de transaction', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.qr_code_2_rounded, size: 72, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                _ReceiptRow(label: 'Référence', value: transaction.reference),
                _ReceiptRow(label: 'Expéditeur', value: 'Jean Dupont'),
                _ReceiptRow(label: 'Bénéficiaire', value: transaction.beneficiary.fullName),
                _ReceiptRow(label: 'Corridor', value: transaction.corridor),
                _ReceiptRow(label: 'Opérateur', value: transaction.operatorName),
                _ReceiptRow(label: 'Montant envoyé', value: '${transaction.amount.toStringAsFixed(0)} ${transaction.currency}'),
                _ReceiptRow(label: 'Frais', value: '${transaction.fee.toStringAsFixed(0)} ${transaction.currency}'),
                _ReceiptRow(label: 'Montant reçu', value: '${transaction.receivedAmount.toStringAsFixed(0)} ${transaction.currency}'),
                const SizedBox(height: 18),
                const Text('Signature numérique MiangPay', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Partager le reçu', icon: Icons.ios_share_rounded, onPressed: () {}),
          const SizedBox(height: 12),
          SecondaryButton(label: 'Télécharger PDF', icon: Icons.download_rounded, onPressed: () {}),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
