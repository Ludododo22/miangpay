import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/fee_quote_model.dart';

class FeeSummaryCard extends StatelessWidget {
  final FeeQuoteModel? quote;

  const FeeSummaryCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final currentQuote = quote;
    if (currentQuote == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)),
      child: Column(children: [
        _Row(label: 'Montant', value: '${currentQuote.amount.toStringAsFixed(0)} ${currentQuote.sourceCurrency}'),
        _Row(label: 'Frais', value: '${currentQuote.fee.toStringAsFixed(0)} ${currentQuote.sourceCurrency}'),
        _Row(label: 'Taux', value: currentQuote.exchangeRate.toStringAsFixed(2)),
        const Divider(height: 28),
        _Row(label: 'Le bénéficiaire reçoit', value: '${currentQuote.receivedAmount.toStringAsFixed(0)} ${currentQuote.destinationCurrency}', isTotal: true),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _Row({required this.label, required this.value, this.isTotal = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: isTotal ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600)),
        Text(value, style: TextStyle(color: isTotal ? AppColors.secondary : AppColors.textPrimary, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
