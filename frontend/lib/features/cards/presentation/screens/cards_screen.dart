import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/cards/transaction_card.dart';
import '../../../../core/design_system/cards/virtual_card_widget.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cards_providers.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cartes virtuelles')),
      body: cardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Impossible de charger les cartes',
          message: 'Réessayez dans quelques instants.',
        ),
        data: (cards) {
          if (cards.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Expanded(
                    child: AppEmptyState(
                      icon: Icons.credit_card_off_rounded,
                      title: 'Aucune carte virtuelle',
                      message: 'Créez une carte MiangPay pour payer en ligne et gérer vos limites.',
                    ),
                  ),
                  PrimaryButton(
                    label: 'Créer une carte',
                    icon: Icons.add_card_rounded,
                    onPressed: () => context.go('/cards/create'),
                  ),
                ],
              ),
            );
          }

          final firstCard = cards.first;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(cardsProvider),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mes cartes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    TextButton.icon(
                      onPressed: () => context.go('/cards/create'),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Créer'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...cards.map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => context.go('/cards/detail/${card.id}'),
                      child: VirtualCardWidget(
                        holder: card.holderName,
                        balance: card.balance.toStringAsFixed(0),
                        currency: card.currency,
                        lastDigits: card.lastDigits,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: 'Recharger ma carte principale',
                  icon: Icons.add_rounded,
                  onPressed: () => context.go('/cards/topup/${firstCard.id}'),
                ),
                const SizedBox(height: 24),
                const Text('Dernières opérations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                ref.watch(cardTransactionsProvider(firstCard.id)).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (transactions) => Column(
                    children: transactions.take(3).map((tx) {
                      final sign = tx.isCredit ? '+' : '-';
                      return TransactionCard(
                        title: tx.merchant,
                        subtitle: tx.subtitle,
                        amount: '$sign${tx.amount.toStringAsFixed(0)} ${tx.currency}',
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
