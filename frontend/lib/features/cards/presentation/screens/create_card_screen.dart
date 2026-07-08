import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cards_providers.dart';

class CreateCardScreen extends ConsumerStatefulWidget {
  const CreateCardScreen({super.key});

  @override
  ConsumerState<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends ConsumerState<CreateCardScreen> {
  String _currency = 'XOF';
  double _dailyLimit = 100000;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Créer une carte')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Carte virtuelle MiangPay', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 8),
          const Text(
            'Créez une carte pour payer en ligne, définir vos limites et contrôler votre sécurité.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Text('Devise', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: ['XOF', 'XAF', 'USD'].map((currency) {
              final selected = _currency == currency;
              return ChoiceChip(
                label: Text(currency),
                selected: selected,
                selectedColor: AppColors.secondary.withValues(alpha: .16),
                onSelected: (_) => setState(() => _currency = currency),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Limite quotidienne', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...[100000.0, 250000.0, 500000.0].map((limit) {
            final selected = _dailyLimit == limit;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: selected ? AppColors.secondary : Colors.transparent, width: 1.5),
              ),
              child: RadioListTile<double>(
                value: limit,
                groupValue: _dailyLimit,
                onChanged: (value) => setState(() => _dailyLimit = value ?? limit),
                title: Text('${limit.toStringAsFixed(0)} $_currency', style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: const Text('Modifiable après création'),
                activeThumbColor: AppColors.secondary,
              ),
            );
          }),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
            activeThumbColor: AppColors.secondary,
            contentPadding: EdgeInsets.zero,
            title: const Text('J’accepte les conditions d’utilisation de la carte virtuelle.'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Créer ma carte',
            icon: Icons.add_card_rounded,
            isLoading: _isLoading,
            onPressed: _acceptTerms ? _createCard : null,
          ),
        ],
      ),
    );
  }

  Future<void> _createCard() async {
    setState(() => _isLoading = true);
    final card = await ref.read(cardsRepositoryProvider).createCard(currency: _currency, dailyLimit: _dailyLimit);
    ref.invalidate(cardsProvider);
    if (mounted) context.go('/cards/detail/${card.id}');
  }
}
