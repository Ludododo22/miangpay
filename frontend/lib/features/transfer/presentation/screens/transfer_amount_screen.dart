import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';
import '../widgets/amount_input_card.dart';
import '../widgets/fee_summary_card.dart';

class TransferAmountScreen extends ConsumerWidget {
  const TransferAmountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transferDraftProvider);
    final currency = draft.sourceCountry?.currency ?? 'XOF';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Montant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(draft.beneficiary?.fullName ?? 'Bénéficiaire', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 6),
          Text('${draft.beneficiary?.country.flag ?? ''} ${draft.beneficiary?.operator.name ?? ''}', style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          AmountInputCard(currency: currency, onChanged: (amount) => ref.read(transferDraftProvider.notifier).setAmount(amount)),
          const SizedBox(height: 18),
          FeeSummaryCard(quote: draft.quote),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Voir le résumé', icon: Icons.receipt_long_rounded, onPressed: draft.quote == null ? null : () => context.go('/transfer/summary')),
        ]),
      ),
    );
  }
}
