import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/activity_transaction_model.dart';
import '../providers/history_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Activités')),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Impossible de charger l’historique',
          message: 'Vérifiez votre connexion puis réessayez.',
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const AppEmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'Aucune transaction',
              message: 'Vos transferts apparaîtront ici.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const AppTextField(
                label: 'Rechercher',
                hint: 'Référence, bénéficiaire, montant...',
                prefixIcon: Icons.search_rounded,
              ),
              const SizedBox(height: 16),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  StatusBadge(label: 'Toutes'), SizedBox(width: 8),
                  StatusBadge(label: 'Réussies', status: AppStatus.success), SizedBox(width: 8),
                  StatusBadge(label: 'En cours', status: AppStatus.pending), SizedBox(width: 8),
                  StatusBadge(label: 'Échecs', status: AppStatus.failed),
                ]),
              ),
              const SizedBox(height: 24),
              const Text('Transactions récentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              ...transactions.map((transaction) => _TransactionActivityTile(transaction: transaction)),
            ],
          );
        },
      ),
    );
  }
}

class _TransactionActivityTile extends StatelessWidget {
  final ActivityTransactionModel transaction;

  const _TransactionActivityTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final status = switch (transaction.status) {
      'success' => AppStatus.success,
      'pending' => AppStatus.pending,
      _ => AppStatus.failed,
    };

    final statusLabel = switch (transaction.status) {
      'success' => 'Réussi',
      'pending' => 'En cours',
      _ => 'Échec',
    };

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/history/detail/${transaction.reference}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.secondary.withValues(alpha: .12),
              child: Text(transaction.beneficiary.initials, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.beneficiary.fullName, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('${transaction.corridor} • ${transaction.operatorName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  StatusBadge(label: statusLabel, status: status),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('-${transaction.amount.toStringAsFixed(0)} ${transaction.currency}', style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(transaction.reference, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
