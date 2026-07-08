import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/cards/transaction_card.dart';
import '../../../../core/design_system/cards/virtual_card_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cards_providers.dart';
import '../widgets/card_action_tile.dart';

class CardDetailScreen extends ConsumerWidget {
  final String cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(selectedCardProvider(cardId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Détail carte')),
      body: cardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (card) {
          if (card == null) return const Center(child: Text('Carte introuvable'));

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              VirtualCardWidget(
                holder: card.holderName,
                balance: card.balance.toStringAsFixed(0),
                currency: card.currency,
                lastDigits: card.lastDigits,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InfoBox(label: 'Statut', value: card.isFrozen ? 'Gelée' : 'Active'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _InfoBox(label: 'Expiration', value: card.expiry)),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Recharger',
                icon: Icons.add_rounded,
                onPressed: () => context.go('/cards/topup/${card.id}'),
              ),
              const SizedBox(height: 24),
              const Text('Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              CardActionTile(
                icon: Icons.visibility_rounded,
                title: 'Voir les informations',
                subtitle: 'Numéro, date et CVV protégés par PIN',
                onTap: () => _showSensitiveInfo(context, card.lastDigits),
              ),
              CardActionTile(
                icon: card.isFrozen ? Icons.lock_open_rounded : Icons.lock_rounded,
                title: card.isFrozen ? 'Débloquer la carte' : 'Bloquer la carte',
                subtitle: card.isFrozen ? 'Réactiver les paiements' : 'Geler temporairement les paiements',
                onTap: () async {
                  await ref.read(cardsRepositoryProvider).toggleFreeze(card.id);
                  ref.invalidate(cardsProvider);
                  ref.invalidate(selectedCardProvider(card.id));
                },
              ),
              CardActionTile(
                icon: Icons.tune_rounded,
                title: 'Paramètres de la carte',
                subtitle: 'Limites et paiements en ligne',
                onTap: () => context.go('/cards/settings/${card.id}'),
              ),
              const SizedBox(height: 24),
              const Text('Historique carte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              ref.watch(cardTransactionsProvider(card.id)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
                data: (transactions) => Column(
                  children: transactions.map((tx) {
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
          );
        },
      ),
    );
  }

  void _showSensitiveInfo(BuildContext context, String lastDigits) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informations sécurisées', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            _SecureRow(label: 'Numéro', value: '4532 8900 4421 $lastDigits'),
            const SizedBox(height: 12),
            const _SecureRow(label: 'Expiration', value: '09/29'),
            const SizedBox(height: 12),
            const _SecureRow(label: 'CVV', value: '•••'),
            const SizedBox(height: 16),
            const Text('Dans la version connectée, un PIN ou la biométrie sera requis.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ]),
    );
  }
}

class _SecureRow extends StatelessWidget {
  final String label;
  final String value;

  const _SecureRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
    ]);
  }
}
