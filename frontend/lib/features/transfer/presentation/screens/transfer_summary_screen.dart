import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';
import '../widgets/fee_summary_card.dart';

class TransferSummaryScreen extends ConsumerWidget {
  const TransferSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transferDraftProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Résumé')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Vérifiez avant de confirmer', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              _line('Expéditeur', 'Jean Dupont'),
              _line('Origine', '${draft.sourceCountry?.flag ?? ''} ${draft.sourceCountry?.name ?? '-'}'),
              _line('Destinataire', draft.beneficiary?.fullName ?? '-'),
              _line('Destination', '${draft.beneficiary?.country.flag ?? ''} ${draft.beneficiary?.country.name ?? '-'}'),
              _line('Opérateur', draft.beneficiary?.operator.name ?? '-'),
            ]),
          ),
          const SizedBox(height: 18),
          FeeSummaryCard(quote: draft.quote),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Confirmer avec PIN', icon: Icons.lock_rounded, onPressed: () => context.go('/transfer/pin')),
        ]),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w900))),
      ]),
    );
  }
}
