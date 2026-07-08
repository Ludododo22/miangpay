import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/history_providers.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String reference;

  const TransactionDetailScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(transactionByReferenceProvider(reference));

    if (transaction == null) {
      return const Scaffold(
        body: AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'Transaction introuvable',
          message: 'Cette référence n’existe pas dans les données de démonstration.',
        ),
      );
    }

    final status = switch (transaction.status) {
      'success' => AppStatus.success,
      'pending' => AppStatus.pending,
      _ => AppStatus.failed,
    };
    final statusLabel = switch (transaction.status) {
      'success' => 'Transaction réussie',
      'pending' => 'Traitement en cours',
      _ => 'Transaction échouée',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Détail transaction')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Icon(transaction.status == 'success' ? Icons.check_circle_rounded : Icons.hourglass_top_rounded, color: transaction.status == 'success' ? AppColors.success : AppColors.warning, size: 64),
                const SizedBox(height: 12),
                Text(statusLabel, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                StatusBadge(label: statusLabel.replaceAll('Transaction ', ''), status: status),
                const SizedBox(height: 20),
                Text('${transaction.receivedAmount.toStringAsFixed(0)} ${transaction.currency}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary)),
                const Text('Montant reçu estimé', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _InfoCard(title: 'Participants', rows: {
            'Expéditeur': 'Jean Dupont',
            'Destinataire': transaction.beneficiary.fullName,
            'Téléphone': transaction.beneficiary.phone,
          }),
          const SizedBox(height: 16),
          _InfoCard(title: 'Détails financiers', rows: {
            'Montant envoyé': '${transaction.amount.toStringAsFixed(0)} ${transaction.currency}',
            'Frais': '${transaction.fee.toStringAsFixed(0)} ${transaction.currency}',
            'Montant reçu': '${transaction.receivedAmount.toStringAsFixed(0)} ${transaction.currency}',
          }),
          const SizedBox(height: 16),
          _InfoCard(title: 'Corridor', rows: {
            'Pays': transaction.corridor,
            'Opérateur': transaction.operatorName,
            'Référence': transaction.reference,
          }),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Voir le reçu', icon: Icons.receipt_long_rounded, onPressed: () => context.push('/history/receipt/${transaction.reference}')),
          const SizedBox(height: 12),
          SecondaryButton(label: 'Refaire ce transfert', icon: Icons.repeat_rounded, onPressed: () => context.go('/transfer')),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Map<String, String> rows;

  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 12),
          ...rows.entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: const TextStyle(color: AppColors.textSecondary)),
                Flexible(child: Text(entry.value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
