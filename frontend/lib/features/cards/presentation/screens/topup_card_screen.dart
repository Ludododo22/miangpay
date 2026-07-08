import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cards_providers.dart';

class TopUpCardScreen extends ConsumerStatefulWidget {
  final String cardId;

  const TopUpCardScreen({super.key, required this.cardId});

  @override
  ConsumerState<TopUpCardScreen> createState() => _TopUpCardScreenState();
}

class _TopUpCardScreenState extends ConsumerState<TopUpCardScreen> {
  final _amountController = TextEditingController(text: '50000');
  String _source = 'MTN Mobile Money';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardAsync = ref.watch(selectedCardProvider(widget.cardId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Recharger la carte')),
      body: cardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (card) {
          if (card == null) return const Center(child: Text('Carte introuvable'));
          final amount = double.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;
          final fee = amount * 0.01;
          final credited = amount - fee;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('Source Mobile Money', style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _source,
                items: const [
                  DropdownMenuItem(value: 'MTN Mobile Money', child: Text('MTN Mobile Money')),
                  DropdownMenuItem(value: 'Orange Money', child: Text('Orange Money')),
                  DropdownMenuItem(value: 'Airtel Money', child: Text('Airtel Money')),
                  DropdownMenuItem(value: 'Moov Money', child: Text('Moov Money')),
                ],
                onChanged: (value) => setState(() => _source = value ?? _source),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Montant',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.payments_rounded,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  _Row(label: 'Vous rechargez', value: '${amount.toStringAsFixed(0)} ${card.currency}'),
                  const Divider(height: 24),
                  _Row(label: 'Frais estimés', value: '${fee.toStringAsFixed(0)} ${card.currency}'),
                  const Divider(height: 24),
                  _Row(label: 'Montant crédité', value: '${credited.toStringAsFixed(0)} ${card.currency}', highlight: true),
                ]),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Confirmer la recharge',
                icon: Icons.check_circle_rounded,
                isLoading: _isLoading,
                onPressed: amount > 0 ? () => _topUp(amount) : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _topUp(double amount) async {
    setState(() => _isLoading = true);
    await ref.read(cardsRepositoryProvider).topUp(widget.cardId, amount);
    ref.invalidate(cardsProvider);
    ref.invalidate(selectedCardProvider(widget.cardId));
    ref.invalidate(cardTransactionsProvider(widget.cardId));
    if (mounted) context.go('/cards/detail/${widget.cardId}');
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _Row({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: highlight ? AppColors.secondary : AppColors.textPrimary)),
    ]);
  }
}
